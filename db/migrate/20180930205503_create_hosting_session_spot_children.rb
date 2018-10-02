class CreateHostingSessionSpotChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :hosting_session_spot_children do |t|
      t.integer :child_id
      t.integer :hosting_session_spot_id

      t.timestamps
    end
  end
end
