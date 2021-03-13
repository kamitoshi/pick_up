class CreateShopTags < ActiveRecord::Migration[5.2]
  def change
    create_table :shop_tags do |t|
      t.references :shop, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
