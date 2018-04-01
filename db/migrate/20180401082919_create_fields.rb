class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :label_name
      t.string :label_bound
      t.string :value_bound
      t.timestamps
    end
  end
end
