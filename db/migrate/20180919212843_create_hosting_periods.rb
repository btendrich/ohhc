class CreateHostingPeriods < ActiveRecord::Migration[5.1]
  def change
    create_table :hosting_periods do |t|
      t.string :name
      t.date :begins
      t.boolean :visible

      t.timestamps
    end
  end
end
