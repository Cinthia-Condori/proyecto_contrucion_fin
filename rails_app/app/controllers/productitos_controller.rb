# 222222222222222222222222222222222222
class ProductitosController < ApplicationController
  require 'bunny'
  require 'json'

  # 🔹 Enviar productos de una categoría a RabbitMQ
  def send_to_queue
    categoria = params[:categoria]

    # Obtener todos los datos de los productos de la categoría usando ActiveRecord
    productos = Producto.joins(:category)
                        .where(categories: { name: categoria })
                        .select(:id, :titulo, :description, :price, :stock, :imagen_url) # Selecciona los datos necesarios

    if productos.empty?
      flash[:alert] = "No hay productos en la categoría #{categoria}."
      redirect_to index1_productitos_path and return
    end

    productos_json = productos.as_json # Convierte los productos a formato JSON

    begin
      RabbitmqPublisher.publish(productos_json, categoria)
      flash[:notice] = "Productos de la categoría #{categoria} enviados a RabbitMQ."
    rescue StandardError => e
      flash[:alert] = "❌ Error al enviar productos a RabbitMQ: #{e.message}"
    end

    redirect_to index1_productitos_path
  end

  # 🔹 Enviar productos de una categoría a RabbitMQ desde ventas online
  def send_to_queue_ventas_online
    categoria = params[:categoria]

    # Obtener todos los datos de los productos de la categoría usando ActiveRecord
    productos = Producto.joins(:category)
                        .where(categories: { name: categoria })
                        .select(:id, :titulo, :description, :price, :stock) # Selecciona los datos necesarios

    if productos.empty?
      flash[:alert] = "No hay productos en la categoría #{categoria}."
      redirect_to ventas_online_productitos_path and return
    end

    productos_json = productos.as_json # Convierte los productos a formato JSON

    begin
      RabbitmqPublisher.publish(productos_json, categoria)
      flash[:notice] = "Productos de la categoría #{categoria} enviados a RabbitMQ."
    rescue StandardError => e
      flash[:alert] = "❌ Error al enviar productos a RabbitMQ: #{e.message}"
    end

    redirect_to ventas_online_productitos_path
  end

  # # 🔹 Enviar productos de una categoría a RabbitMQ desde una URL específica
  # def send_to_queue_productitos
  #   categoria = params[:categoria]

  #   # Obtener todos los datos de los productos de la categoría usando ActiveRecord
  #   productos = Producto.joins(:category)
  #                       .where(categories: { name: categoria })
  #                       .select(:id, :titulo, :description, :price, :stock,:imagen_url) # Selecciona los datos necesarios

  #   if productos.empty?
  #     flash[:alert] = "No hay productos en la categoría #{categoria}."
  #     redirect_to index1_productitos_path and return
  #   end

  #   productos_json = productos.as_json # Convierte los productos a formato JSON

  #   begin
  #     RabbitmqPublisher.publish(productos_json, categoria)
  #     flash[:notice] = "Productos de la categoría #{categoria} enviados a RabbitMQ."
  #   rescue StandardError => e
  #     flash[:alert] = "❌ Error al enviar productos a RabbitMQ: #{e.message}"
  #   end

  #   redirect_to index1_productitos_path
  # end



# ==========================================================

def send_to_queue_productitos
  categoria = params[:categoria]

  productos = Producto.joins(:category)
                      .where(categories: { name: categoria })
                      .select(:id, :titulo, :description, :price, :stock, :imagen_url)

  if productos.empty?
    flash[:alert] = "No hay productos en la categoría #{categoria}."
    redirect_to index1_productitos_path and return
  end

  # Convertir los productos a JSON asegurándose de incluir la URL
  productos_json = productos.map do |producto|
    {
      id: producto.id,
      titulo: producto.titulo,
      description: producto.description,
      price: producto.price,
      stock: producto.stock,
      imagen_url: producto.imagen_url # Asegurar que la URL se incluya
    }
  end.to_json

  begin
    RabbitmqPublisher.publish(productos_json, categoria)
    flash[:notice] = "Productos de la categoría #{categoria} enviados a RabbitMQ."
  rescue StandardError => e
    flash[:alert] = "❌ Error al enviar productos a RabbitMQ: #{e.message}"
  end

  redirect_to index1_productitos_path
end










  # 🔹 Obtener todas las categorías disponibles
  def index1
    @categories = Category.distinct.pluck(:name) # Optimizado con ActiveRecord
    Rails.logger.debug "Categorías obtenidas: #{@categories.inspect}"
  end

  # 🔹 Obtener todas las categorías disponibles para ventas online
  def ventas_online
    @categories = Category.distinct.pluck(:name) # Optimizado con ActiveRecord
    Rails.logger.debug "Categorías obtenidas: #{@categories.inspect}"
     
  end

  # 🔹 Recibir mensajes desde RabbitMQ
  def mensajes
    @mensajes = RabbitmqSubscriber.get_mensajes
    
  end

  private

  # 🔹 Método para recibir mensajes desde RabbitMQ
  def recibir_mensajes
    mensajes = []
    connection = Bunny.new(hostname: 'rabbitmq', user: 'guest', password: 'guest')

    begin
      connection.start
      channel = connection.create_channel
      queue = channel.queue('productos_categoria', durable: true)

      puts "✅ Conectado a RabbitMQ, recibiendo mensajes..."

      # Obtener mensajes pendientes en la cola
      while (msg = queue.pop[2]) # pop[2] obtiene el mensaje JSON
        mensajes << JSON.parse(msg) if msg
      end

      puts "📥 Mensajes recibidos: #{mensajes.inspect}"
    rescue StandardError => e
      puts "❌ Error al recibir mensajes: #{e.message}"
    ensure
      connection.close if connection&.open?
      puts "🔌 Conexión a RabbitMQ cerrada."
    end

    mensajes
  end
end
