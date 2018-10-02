class CreateChildNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :child_notes do |t|
      t.integer :child_id
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
