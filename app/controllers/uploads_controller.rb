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
      project: "first-ocr-project", #Quenvin's project name
      keyfile: JSON.parse(ENV['GOOGLECLOUD_API_KEY'])
      
      # project: "Jscript test", #Fred's project name
      # keyfile: "Jscript test-dcca47f5a8b6.json"
      )


    vision_data = vision.image(upload.photo.path)
    
    raw_data = ProcessRawImageService.new(vision_data, upload).call

    raw = CreateRawDataService.new(raw_data).call
    template_id = CheckExistingTemplateService.new(raw).call
    #ExtractImageValuesService.new(template_id, raw).call
    redirect_to new_upload_path
  end

  private
  def upload_params
    params.require(:upload).permit(:photo)
  end


end
