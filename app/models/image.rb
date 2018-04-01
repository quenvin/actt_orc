class Image < ApplicationRecord
  belongs_to :upload
  has_one :raw
end
