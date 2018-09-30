class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :name
      t.date :beings
      t.boolean :public

      t.timestamps
    end
  end
end
