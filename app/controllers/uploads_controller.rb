class UploadsController < ApplicationController
  def new
    @upload = Upload.new
  end

  def create
    upload = Upload.new(upload_params)
    upload.save
    require "google/cloud/vision"
    vision = Google::Cloud::Vision.new(
      project: "first-ocr-project",
      keyfile: JSON.parse(ENV['GOOGLECLOUD_API_KEY'])
      )
      raw_data = vision.image(Upload.last.photo.path)
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
