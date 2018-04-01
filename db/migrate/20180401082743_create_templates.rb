class CreateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :templates do |t|
      t.string :template_name
      t.string :sample_path
      t.timestamps
    end
  end
end
