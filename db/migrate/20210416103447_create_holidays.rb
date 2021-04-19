class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.references :shop, foreign_key: true
      t.integer :weekday, null: false

      t.timestamps
    end
  end
end
