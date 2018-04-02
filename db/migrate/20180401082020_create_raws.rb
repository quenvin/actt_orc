class CreateRaws < ActiveRecord::Migration[5.1]
  def change
    create_table :raws do |t|
      t.references :image, foreign_key: true
      t.string :raw_data
      t.timestamps
    end
  end
end
