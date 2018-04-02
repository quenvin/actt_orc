class Raw < ApplicationRecord
  belongs_to :image
  serialize :raw_data
end
