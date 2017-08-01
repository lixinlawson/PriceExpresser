class AddCatalogToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :catalog, :string
  end
end
