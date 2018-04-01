class Upload < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  has_one :image
end
