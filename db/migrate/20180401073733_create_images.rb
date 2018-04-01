class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.references :upload, foreign_key: true
      t.string :processed_photo
      t.timestamps
    end
  end
end
