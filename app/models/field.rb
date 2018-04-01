class Field < ApplicationRecord
  serialize :label_bound
  serialize :value_bound

  has_many :fields_templates
end
