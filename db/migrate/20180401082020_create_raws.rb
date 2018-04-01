class CreateRaws < ActiveRecord::Migration[5.1]
  def change
    create_table :raws do |t|

      t.timestamps
    end
  end
end
