class CreateSiblings < ActiveRecord::Migration[5.1]
  def change
    create_table :siblings do |t|
      t.integer :child_id
      t.integer :sibling_id

      t.timestamps
    end
  end
end
