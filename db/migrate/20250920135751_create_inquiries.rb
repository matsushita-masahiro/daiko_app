class CreateInquiries < ActiveRecord::Migration[8.0]
  def change
    create_table :inquiries do |t|
      t.string :name
      t.string :email
      t.string :furigana
      t.string :inquiry_type
      t.string :phone
      t.text :address
      t.text :content

      t.timestamps
    end
  end
end
