class CreateChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :children do |t|
      t.string :name
      t.string :country
      t.string :size
      t.string :age_range
      t.string :gender
      t.text :description
      t.text :notes

      t.timestamps
    end
  end
end
