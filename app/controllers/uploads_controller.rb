class UploadsController < ApplicationController
  def new
    @upload = Upload.new
    @showall = Upload.all
  end

  def create
    upload = Upload.new(upload_params)
    upload.save

    require "google/cloud/vision"
    vision = Google::Cloud::Vision.new(
      #project: "first-ocr-project", #Quenvin's project name
      project: "Jscript test", #Fred's project name
      #keyfile: JSON.parse(ENV['GOOGLECLOUD_API_KEY'])
      
      keyfile: "Jscript test-dcca47f5a8b6.json"
      )


    image = vision.image(Upload.last.photo.path)
    doc_text_bound = image.document.bounds
    word = image.document.words

    #Height and width of boundary 
    boundary_width = doc_text_bound[1].x - doc_text_bound[0].x 
    boundary_height = doc_text_bound[3].y - doc_text_bound[1].y 

    #Padding top and left to start of boundary 
    boundary_padding_left = doc_text_bound[0].x 
    boundary_padding_top = doc_text_bound[0].y 

    #Center point of boundary 
    center_point = [boundary_width/2 + boundary_padding_left, boundary_height/2 + boundary_padding_top] 
    
    #For each word, find the distance of X and Y to it's respective center point 
    center_word = [] 
    counter = 0 
    word.each do |w| 

    x_to_center = (w.bounds[0].x - center_point[0]).abs 
    y_to_center = (w.bounds[0].y - center_point[1]).abs 

      #if center word array is empty, load the first word into it 
      if center_word.empty? 
        center_word << counter 
        center_word << x_to_center 
        center_word << y_to_center 
      else 
        #Compare the distance with the previous word, replace if it's closer to the center 
        if center_word[1] > x_to_center && center_word[2] > y_to_center 
          center_word.clear 
          center_word << counter 
          center_word << x_to_center 
          center_word << y_to_center 
         end 
      end 
      counter += 1 
    end 

    #Variable for targeted word 
    word = word[center_word[0]] 

    #Find the required co-ordinates for the center word 
    topleft = [word.to_h[:bounds][0][:x], word.to_h[:bounds][0][:y]] 
    bottomleft = [word.to_h[:bounds][3][:x], word.to_h[:bounds][3][:y]] 

    #Height difference between top left and bottom left 
    height_diff = bottomleft[1] - topleft[1] 

    #Width difference between top left and bottom left 
    width_diff = topleft[0] - bottomleft[0] 

    #Find the Radius using Pythagoras theorem 
    radius = Math.sqrt((height_diff ** 2) + (width_diff ** 2)) 

    #Find the point of x2y2 using the values from variable bottom left 
    #Add radius to Y, no changes to X as it serves as the center point of circle 
    x2y2 = [word.to_h[:bounds][3][:x], word.to_h[:bounds][3][:y] + radius] 

    #Find the distance between the x2y2 and x1y1 
    x1_minus_x2 = word.to_h[:bounds][0][:x] - word.to_h[:bounds][3][:x]
    y1_minus_y2 = word.to_h[:bounds][0][:y] - word.to_h[:bounds][3][:y] + radius
    distance = Math.sqrt((x1_minus_x2 ** 2) + (y1_minus_y2 ** 2))
      
    #Find the angle 
    angle = Math.acos(1-((distance ** 2) / (2 * radius ** 2)))
    angle = angle * 180 / Math::PI

    #Find the rotation direction
    word.to_h[:bounds][0][:x] > x2y2[0] ? rotation = "right" : rotation = "left"
      
    #Rotate and crop image and save processed image to image table
    new_image = Image.new(upload_id: upload.id, processed_photo: Upload.last.photo.file.filename)
    new_image.save

    image = MiniMagick::Image.open(Upload.last.photo.path)
    image.path

    image.rotate -angle if rotation == "right"
    image.rotate angle if rotation == "left"    

    crop_img = vision.image(image.path)
    crop_doc_text_bound = crop_img.document.bounds

    crop_boundary_width = crop_doc_text_bound[1].x - crop_doc_text_bound[0].x
    crop_boundary_height = crop_doc_text_bound[3].y - crop_doc_text_bound[1].y

    crop_boundary_padding_left = crop_doc_text_bound[0].x
    crop_boundary_padding_top = crop_doc_text_bound[0].y

    image.crop "#{crop_boundary_width}X#{crop_boundary_height}+#{crop_boundary_padding_left}+#{crop_boundary_padding_top}"
    image.resize "700X1000!"

    processed_img = image.write "app/assets/images/#{Image.last.processed_photo}"

    p_image = vision.image("app/assets/images/#{Image.last.processed_photo}")
    raw_data = p_image #Returns all the processed image's vision data

    raw = CreateRawDataService.new(raw_data).call
    template_id = CheckExistingTemplateService.new(raw).call
    ExtractImageValuesService.new(template_id, raw).call
    redirect_to new_upload_path
  end

  private
  def upload_params
    params.require(:upload).permit(:photo)
  end

end
