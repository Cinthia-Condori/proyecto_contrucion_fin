class AddImagenUrlToProductos < ActiveRecord::Migration[7.1]
  def change
    add_column :productos, :imagen_url, :string
  end
end
