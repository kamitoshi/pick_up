class CreateMenuTags < ActiveRecord::Migration[5.2]
  def change
    create_table :menu_tags do |t|
      t.references :menu, foreign_key: true
      t.string :content, null: false

      t.timestamps
    end
  end
end
