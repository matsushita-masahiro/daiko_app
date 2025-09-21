class CreatePageViews < ActiveRecord::Migration[8.0]
  def change
    create_table :page_views do |t|
      t.string :ip_address
      t.string :user_agent
      t.string :page_path
      t.datetime :visited_at

      t.timestamps
    end
  end
end
