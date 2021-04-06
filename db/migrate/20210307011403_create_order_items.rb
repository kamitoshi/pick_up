class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.references :order, foreign_key: true
      t.references :menu, foreign_key: true
      t.string :menu_name, null: false
      t.integer :menu_price, null: false
      t.integer :menu_fee, null: false
      t.integer :menu_amount, null: false

      t.timestamps
    end
  end
end
