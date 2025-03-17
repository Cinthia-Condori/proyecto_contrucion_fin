require 'bunny'
require 'json'

class CategoriaSubscriber
  @@categorias_recibidas = []  # Almacenar las categorías recibidas
  @@mutex = Mutex.new # Para manejar concurrencia

  def self.listen
    puts "📡 Iniciando conexión a RabbitMQ para recibir categorías..."

    begin
      connection = Bunny.new(hostname: 'rabbitmq', user: 'guest', password: 'guest')
      connection.start
      puts "✅ Conexión a RabbitMQ establecida."

      channel = connection.create_channel
      exchange = channel.direct('categorias_exchange', durable: true)

      queue_name = "categorias_queue"
      routing_key = "todas_categorias"

      queue = channel.queue(queue_name, durable: true)
      queue.bind(exchange, routing_key: routing_key)

      puts "[*] Suscrito a la cola: #{queue_name} | Clave: #{routing_key}"

      # Procesar mensajes de la cola
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

        if mensaje['categorias'].is_a?(Array)
          @@mutex.synchronize do
            @@categorias_recibidas.concat(mensaje['categorias'])
          end
          puts "✅ Categorías procesadas correctamente: #{mensaje['categorias'].inspect}"
        else
          puts "⚠️ Mensaje con estructura inválida: #{mensaje.inspect}"
        end
      rescue JSON::ParserError => e
        puts "❌ Error al parsear JSON: #{e.message}"
      end
    end
  end

  # 🔹 Método para obtener las categorías almacenadas
  def self.get_categorias
    @@mutex.synchronize { @@categorias_recibidas.dup }
  end
end

# Ejecutar en un hilo separado para escuchar los mensajes
Thread.new { CategoriaSubscriber.listen }
