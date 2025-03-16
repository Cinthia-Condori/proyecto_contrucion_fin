class VentasOnlineController < ApplicationController
    require 'bunny'
    require 'json'
    require_dependency 'categoria_publisher' # Asegúrate de que este archivo existe en `app/lib/`
  
    # Método para enviar todas las categorías a RabbitMQ en una sola cola
    def send_to_queue
      categorias = params[:categorias] || []
  
      if categorias.empty?
        flash[:alert] = "⚠️ Debes seleccionar al menos una categoría antes de publicar."
        redirect_to ventas_online_path and return
      end
  
      # Mostrar en consola qué categorías se van a enviar
      puts "📌 Enviando categorías a RabbitMQ: #{categorias.inspect}"
  
      begin
        # Enviar todas las categorías en una sola cola
        CategoriaPublisher.publish(categorias)
        flash[:notice] = "✅ Todas las categorías enviadas correctamente a RabbitMQ en una sola cola."
      rescue StandardError => e
        flash[:alert] = "❌ Error al enviar categorías a RabbitMQ: #{e.message}"
      end
  
      redirect_to ventas_online_path
    end
  
    # Método para cargar todas las categorías en la vista
    def index
      @categories = Category.distinct.pluck(:name)
      Rails.logger.debug "📌 Categorías obtenidas para la vista: #{@categories.inspect}"
      render 'ventas_online/index2'
    end
  end
  