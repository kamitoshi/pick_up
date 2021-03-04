class AddGenreToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :genre, :integer
  end
end
