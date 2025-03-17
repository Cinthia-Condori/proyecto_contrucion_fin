class AddUrlToProductos < ActiveRecord::Migration[7.1]
  def change
    add_column :productos, :url, :string
  end
end
