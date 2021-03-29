class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.references :shop, foreign_key: true
      t.string :name, null: false
      t.integer :menu_type, null: false
      t.integer :price, null: false
      t.integer :fee, null: false
      t.integer :estimated_time, null: false
      t.text :introduction
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
