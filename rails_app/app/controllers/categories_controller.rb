class CategoriesController < ApplicationController
  before_action :authorize!
  require_dependency 'categoria_publisher'


  def index
    @categories = Category.all.order(name: :asc)
  end

  def new
    @category = Category.new
  end

  def edit
    category
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_url, notice: "CATEGORIA CREADA CORRECTAMENTE"
    else
      render :new, status: :unprocessable_entity, alert: t('.alert')
    end
  end

  def update
    if category.update(category_params)
      redirect_to categories_url, notice: "CATEGORIA ACTUALIZADA CORRECTAMENTE"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.productos.each(&:destroy)
    @category.destroy
    redirect_to categories_url, notice: "Categoría eliminada correctamente."
  end

  # ================================
  # 🚀 NUEVAS FUNCIONES PARA RABBITMQ
  # ================================

  # Muestra todos los productos de una categoría específica
  def select_products
    @category = Category.find(params[:id])
    @products = @category.productos  # Busca todos los productos de esa categoría
  end

  # Enviar todos los productos de una categoría a RabbitMQ
  def send_to_queue
    category = Category.find(params[:id])
    products = category.productos

    if products.any?
      RabbitmqPublisher.publish(products)  # Enviar todos los productos a RabbitMQ
      redirect_to categories_path, notice: "Productos enviados correctamente a la cola."
    else
      redirect_to categories_path, alert: "No hay productos en esta categoría."
    end
  end

  private

  def category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
  
  def list
    @categories = Category.all
  end

  def send_to_queue
    categoria = params[:categoria]
    productos = Product.where(category: categoria).pluck(:name) # Obtener productos

    RabbitmqPublisher.publish(categoria, productos)

    flash[:notice] = "Productos de la categoría #{categoria} enviados a RabbitMQ."
    redirect_to selecategoria_list_path
  end
end
