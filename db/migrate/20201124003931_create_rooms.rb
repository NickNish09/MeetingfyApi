class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :capability, default: 5

      t.timestamps
    end
  end
end
