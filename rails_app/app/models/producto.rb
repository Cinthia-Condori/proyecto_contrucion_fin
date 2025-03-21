# class Producto < ApplicationRecord
#   belongs_to :category
#   include PgSearch::Model
#   pg_search_scope :search_full_text, against: {
#     titulo: 'A',
#     description: 'B'
#   }
  
#   ORDER_BY = {
#     newest: "created_at DESC",
#     expensive: "price DESC",
#     cheapest: "price ASC"
#   }

#   #un archivo adjunto foto
#   has_one_attached :photo
#   validates :titulo, presence: true
#   validates :description, presence: true
#   validates :price, presence: true
#   validates :color, presence: true
#   validates :stock, presence: true


#   # para guardar la imgen
#   # Método para obtener la URL de la imagen
#   # Método para obtener la URL de la imagen
#   # ✅ Método para obtener la URL de la imagen desde public/products/
# # ✅ Método para obtener la URL de la imagen
# def photo_url
#   photo_path.present? ? "/products/#{photo_path}" : "/images/placeholder.jpg"
#   # <%= image_tag "/app/asstproducts/#{producto.photo_path}", width: 200, class: "rounded-lg" %>
# end

#   #hacemos que un producto tiene varios favoritos, es decir un producto le puede gustar a varias personas
#   #y si se borra ese producto, sus favoritos tambien se borran
#   has_many :favorites, dependent: :destroy
#   #decimos que el modelo product pertenece a categorias
#   belongs_to :category

#   belongs_to :talla

#   has_many :carritos
  
#   def favorite!
#     favorites.create(user: Current.user)
#   end

#   def unfavorite!
#     favorite.destroy
#   end

#   def favorite
#     favorites.find_by(user: Current.user)
#   end
# end











class Producto < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_full_text, against: {
    titulo: 'A',
    description: 'B'
  }
  
  ORDER_BY = {
    newest: "created_at DESC",
    expensive: "price DESC",
    cheapest: "price ASC"
  }

  #un archivo adjunto foto
  has_one_attached :photo
  # validates :titulo, presence: true
  # validates :description, presence: true
  # validates :price, presence: true
  # validates :color, presence: true
  # validates :stock, presence: true
  # validates :imagen_url, presence: true
  validates :titulo, :description, :price, :color, :stock, :category_id, :talla_id, :imagen_url, presence: true
  #hacemos que un producto tiene varios favoritos, es decir un producto le puede gustar a varias personas
  #y si se borra ese producto, sus favoritos tambien se borran
  has_many :favorites, dependent: :destroy
  #decimos que el modelo product pertenece a categorias
  belongs_to :category

  belongs_to :talla

  has_many :carritos
  
  def favorite!
    favorites.create(user: Current.user)
  end

  def unfavorite!
    favorite.destroy
  end

  def favorite
    favorites.find_by(user: Current.user)
  end
end


