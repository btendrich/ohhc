class CreateChildPhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :child_photos do |t|
      t.integer :child_id
      t.string :description
      t.string :key
      t.integer :row_order

      t.timestamps
    end
  end
end
