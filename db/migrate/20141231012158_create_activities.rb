class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true

      t.integer  :strava_id, default: 0, null: false
      t.string :strava_type, null: false
      t.decimal :distance, null: false
      t.decimal :moving_time
      t.decimal :elapsed_time
      t.datetime :start_date, null: false
      t.datetime :start_date_local
      t.string :timezone
      t.string :name
      t.string :description
    end

    add_index :activities, :strava_id,                unique: true
  end
end
