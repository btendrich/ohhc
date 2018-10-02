class CreateChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :children do |t|
      t.string :first_name
      t.string :last_name
      t.string :identifier
      t.string :country
      t.date :birthday
      t.string :gender
      t.text :description
      t.text :sibling_notes
      t.string :orphanage
      t.text :legal_status

      t.timestamps
    end
  end
end
