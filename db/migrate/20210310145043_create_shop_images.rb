class CreateShopImages < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_images do |t|
      t.references :shop, foreign_key: true
      t.string :file_name
      t.boolean :is_main, default: false

      t.timestamps
    end
  end
end
