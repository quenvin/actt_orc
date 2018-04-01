class Template < ApplicationRecord
  has_many :fields_templates
  has_many :fields, through: :fields_templates
end
