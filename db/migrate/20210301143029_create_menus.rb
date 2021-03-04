class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.references :shop, foreign_key: true
      t.string :name, null: false
      t.integer :price, null: false
      t.integer :special_price
      t.integer :fee, null: false
      t.text :introduction
      t.boolean :is_active, default: true
      t.boolean :is_saling, default: false

      t.timestamps
    end
  end
end
