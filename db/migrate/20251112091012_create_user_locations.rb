class CreateUserLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :user_locations do |t|
      t.decimal :latitude, precision: 10, scale: 6, null: false
      t.decimal :longitude, precision: 10, scale: 6, null: false
      t.string :ip_address, null: false
      t.text :user_agent
      t.string :referer
      t.datetime :visited_at, null: false
      t.datetime :anonymized_at

      t.timestamps
    end

    add_index :user_locations, :visited_at
    add_index :user_locations, [:latitude, :longitude]
    add_index :user_locations, :ip_address
  end
end
