class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs do |t|
      t.string :userId
      t.float :expectedPrice
      t.integer :notified
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
