class CreateSpotStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :spot_statuses do |t|
      t.string :name
      t.boolean :public

      t.timestamps
    end
  end
end
