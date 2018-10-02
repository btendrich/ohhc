class CreateHostingSessionSpots < ActiveRecord::Migration[5.1]
  def change
    create_table :hosting_session_spots do |t|
      t.integer :status_id
      t.integer :hosting_session_id
      t.text :description
      t.integer :scholarship
      t.integer :family_id

      t.timestamps
    end
  end
end
