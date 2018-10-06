class CreateChildFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :child_files do |t|
      t.integer :child_id
      t.string :filename
      t.string :type
      t.string :key
      t.string :description
      t.string :public

      t.timestamps
    end
  end
end
