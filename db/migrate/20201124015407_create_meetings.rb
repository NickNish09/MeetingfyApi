class CreateMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :meetings do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :meeting_start
      t.datetime :meeting_end
      t.string :title

      t.timestamps
    end
  end
end
