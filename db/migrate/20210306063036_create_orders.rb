class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :shop, foreign_key: true
      t.references :user, foreign_key: true
      t.string :reserve_number, null: false
      t.datetime :takeaway_datetime, null: false
      t.text :requested
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
