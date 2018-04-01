class CreateFieldsTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :fields_templates do |t|
      t.references :template, foreign_key: true
      t.references :field, foreign_key: true
      t.timestamps
    end
    add_index :fields_templates, [:template_id, :field_id], unique: true
  end
end
