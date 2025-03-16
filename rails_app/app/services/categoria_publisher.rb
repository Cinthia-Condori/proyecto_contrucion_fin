
# app/services/categoria_publisher.rb
class CategoriaPublisher
  def self.publish(categorias)
    # Verifica que haya categorías antes de enviar
    return puts "❌ No hay categorías para enviar a RabbitMQ." if categorias.empty?

    connection = Bunny.new(hostname: 'rabbitmq', user: 'guest', password: 'guest')

    begin
      connection.start
      puts "✅ Conexión a RabbitMQ establecida."

      channel = connection.create_channel
      exchange = channel.direct('categorias_exchange', durable: true)

      queue_name = "categorias_queue"
      routing_key = "todas_categorias"

      queue = channel.queue(queue_name, durable: true, auto_delete: false)
      queue.bind(exchange, routing_key: routing_key)

      mensaje = { categorias: categorias }.to_json.force_encoding('UTF-8')

      puts "📤 Enviando mensaje a RabbitMQ:"
      puts "🔹 JSON: #{mensaje}"
      puts "🔹 Publicando en la cola '#{queue_name}' con la clave '#{routing_key}'."

      exchange.publish(mensaje, routing_key: routing_key, persistent: true)

      puts "✅ Categorías enviadas correctamente a RabbitMQ."
    rescue Bunny::TCPConnectionFailedForAllHosts => e
      puts "❌ Error de conexión con RabbitMQ: #{e.message}"
    rescue StandardError => e
      puts "❌ Error al enviar el mensaje: #{e.message}"
    ensure
      connection.close if connection&.open?
      puts "🔌 Conexión a RabbitMQ cerrada."
    end
  end
end
