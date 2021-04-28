class CreateShopContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_contacts do |t|
      t.string :shop_name, null: false
      t.string :staff_name
      t.string :phone_number, null: false
      t.string :email, null: false
      t.string :shop_address
      t.text :content
      t.boolean :is_open, default: false

      t.timestamps
    end
  end
end
