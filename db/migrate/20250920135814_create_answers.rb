class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.references :inquiry, null: false, foreign_key: true
      t.text :content
      t.string :admin_name
      t.datetime :answered_at

      t.timestamps
    end
  end
end
