class AddMenuTypeToMenus < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :menu_type, :integer
  end
end
