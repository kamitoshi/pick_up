class CreateBusinessHours < ActiveRecord::Migration[5.2]
  def change
    create_table :business_hours do |t|
      t.references :shop, foreign_key: true
      t.integer :job_time, null: false
      t.time :opening, null: false
      t.time :closing, null: false
      t.time :last_order, null: false

      t.timestamps
    end
  end
end
