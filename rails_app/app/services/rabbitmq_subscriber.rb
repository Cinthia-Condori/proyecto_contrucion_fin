
# 222222222222222222222222222222


# require 'bunny'
# require 'json'

# class RabbitmqSubscriber
#   def self.fetch_messages(categoria)
#     mensajes = [] # Variable local para almacenar los mensajes recibidos

#     begin
#       connection = Bunny.new(hostname: 'rabbitmq', user: 'guest', password: 'guest')
#       connection.start

#       channel = connection.create_channel
#       queue_name = "cola_#{categoria}"  
#       queue = channel.queue(queue_name, durable: true)

#       # Obtener mensajes pendientes en la cola sin esperar indefinidamente
#       puts "📡 Buscando mensajes en la cola #{queue_name}..."
#       while (msg = queue.pop[2]) # `pop[2]` obtiene el mensaje JSON
#         mensajes << JSON.parse(msg) if msg
#       end

      
#       puts "📥 Mensajes recibidos: #{mensajes.inspect}"
#     rescue StandardError => e
#       puts "❌ Error al recibir mensajes: #{e.message}"
#     ensure
#       connection.close if connection&.open?
#       puts "🔌 Conexión a RabbitMQ cerrada."
#     end

#     mensajes
#   end
# end




# # 00000000000000000000000



# require 'bunny'
# require 'json'

# class RabbitmqSubscriber
#   @@mensajes = []  # Almacenar los productos recibidos

#   def self.listen(categoria)
#     puts "📡 Iniciando conexión a RabbitMQ para categoría #{categoria}..."

#     begin
#       connection = Bunny.new(hostname: 'rabbitmq', user: 'guest', password: 'guest')
#       connection.start
#       puts "✅ Conexión a RabbitMQ establecida."

#       channel = connection.create_channel
#       exchange = channel.direct('mi_exchange', durable: true)

#       queue_name = "cola_#{categoria}"
#       routing_key = "customer#{categoria}"

#       queue = channel.queue(queue_name, durable: true)
#       queue.bind(exchange, routing_key: routing_key)

#       puts "[*] Suscrito a la cola: #{queue_name} | Clave: #{routing_key} | Esperando mensajes..."

#       queue.subscribe(manual_ack: false, block: false) do |_delivery_info, _properties, body|
#         begin
#           # 🔥 Solución: Forzar UTF-8 para evitar Encoding::CompatibilityError
#           body.force_encoding("UTF-8")
#           mensaje = JSON.parse(body)

#           puts "📥 Mensaje recibido desde RabbitMQ:\n#{mensaje}"

#           if mensaje['productos'].is_a?(Array)
#             mensaje['productos'].each do |producto|
#               @@mensajes << {
#                 id: producto['id'],
#                 titulo: producto['titulo'],
#                 description: producto['description'],
#                 price: producto['price'],
#                 stock: producto['stock']
#               }
#             end

#             puts "✅ Se recibieron #{mensaje['productos'].size} productos."
#             @@mensajes.each do |producto|
#               puts "🛒 Producto: #{producto[:titulo]} | 💰 Precio: #{producto[:price]} | 📦 Stock: #{producto[:stock]}"
#             end
#           else
#             puts "⚠️ Estructura inesperada en el mensaje: #{mensaje.inspect}"
#           end

#         rescue JSON::ParserError => e
#           puts "❌ Error al parsear JSON: #{e.message}"
#         rescue Encoding::CompatibilityError => e
#           puts "❌ Error de codificación: #{e.message}. Se intentará re-codificar..."
#           body = body.encode("UTF-8", invalid: :replace, undef: :replace, replace: "?")
#           retry
#         rescue StandardError => e
#           puts "❌ Error desconocido: #{e.message}"
#         end
#       end

#     rescue StandardError => e
#       puts "❌ Error en el Subscriber: #{e.message}"
#       puts e.backtrace.join("\n")
#     ensure
#       connection.close if connection&.open?
#       puts "🔌 Conexión a RabbitMQ cerrada."
#     end
#   end

#   def self.get_mensajes
#     @@mensajes
#   end
# end

# # Ejecutar en CLI sin bloquear
# RabbitmqSubscriber.listen('Camiseta')



require 'bunny'
require 'json'

class RabbitmqSubscriber
  @@mensajes = []  # Almacenar los productos recibidos
  @@mutex = Mutex.new # Para evitar problemas de concurrencia

  def self.listen(categoria)
    puts "📡 Iniciando conexión a RabbitMQ para categoría #{categoria}..."

    begin
      connection = Bunny.new(hostname: 'rabbitmq', user: 'guest', password: 'guest')
      connection.start
      puts "✅ Conexión a RabbitMQ establecida."

      channel = connection.create_channel
      exchange = channel.direct('mi_exchange', durable: true)

      queue_name = "cola_#{categoria}"
      routing_key = "customer#{categoria}"

      queue = channel.queue(queue_name, durable: true)
      queue.bind(exchange, routing_key: routing_key)

      puts "[*] Suscrito a la cola: #{queue_name} | Clave: #{routing_key}"

      # Procesar mensajes sin bloquear el sistema
      fetch_messages_from_queue(queue)

    rescue StandardError => e
      puts "❌ Error en el Subscriber: #{e.message}"
    ensure
      connection.close if connection&.open?
      puts "🔌 Conexión a RabbitMQ cerrada."
    end
  end

  # 🔹 Método para obtener mensajes de la cola sin bloquear
  def self.fetch_messages_from_queue(queue)
    while (msg = queue.pop[2]) # pop[2] obtiene el mensaje JSON
      begin
        mensaje = JSON.parse(msg)

        if mensaje['productos'].is_a?(Array)
          @@mutex.synchronize do
            mensaje['productos'].each do |producto|
              @@mensajes << {
                id: producto['id'],
                titulo: producto['titulo'],
                description: producto['description'],
                price: producto['price'],
                stock: producto['stock']
              }
            end
          end
          puts "✅ Mensajes procesados correctamente."
        else
          puts "⚠️ Mensaje con estructura inválida: #{mensaje.inspect}"
        end
      rescue JSON::ParserError => e
        puts "❌ Error al parsear JSON: #{e.message}"
      end
    end
  end

  # 🔹 Método para obtener los mensajes almacenados
  def self.get_mensajes
    @@mutex.synchronize { @@mensajes.dup }
  end
end

# Ejecutar en un hilo separado sin bloquear
Thread.new { RabbitmqSubscriber.listen('Pantalones') }
# Thread.new { RabbitmqSubscriber.listen('Camiseta') }
