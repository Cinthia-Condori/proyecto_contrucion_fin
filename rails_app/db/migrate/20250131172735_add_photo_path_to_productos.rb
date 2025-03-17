class AddPhotoPathToProductos < ActiveRecord::Migration[7.1]
  def change
    add_column :productos, :photo_path, :string
  end
end
