class CreateHostingSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :hosting_sessions do |t|
      t.string :name
      t.date :date
      t.boolean :public

      t.timestamps
    end
  end
end
