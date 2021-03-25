class CreateMenuCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :menu_categories do |t|
      t.references :menu, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
