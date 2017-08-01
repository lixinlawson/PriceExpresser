class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :price
      t.string :source
      t.string :url
      t.string :img
      t.references :product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
