class CreateHostingSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :hosting_sessions do |t|
      t.string :name
      t.string :short_name
      t.date :begins
      t.boolean :public

      t.timestamps
    end
  end
end
