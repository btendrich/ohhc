class CreateSessionSpots < ActiveRecord::Migration[5.1]
  def change
    create_table :session_spots do |t|
      t.integer :child_id
      t.integer :hosting_session_id
      t.integer :spot_status_id
      t.integer :scholarship
      t.integer :row_order
      t.text :public_notes
      t.text :private_notes

      t.timestamps
    end
  end
end
