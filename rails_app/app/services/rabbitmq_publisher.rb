require 'bunny'
require 'json'

class RabbitmqPublisher
  def self.publish(productos, consumidor)
    # Validar que los productos sean un array válido
    if !productos.is_a?(Array) || productos.empty?
      puts "❌ Error: Productos debe ser un array válido y no puede estar vacío."
      return
    end

    # Establecer conexión con RabbitMQ
    # connection = Bunny.new
    # connection = Bunny.new(hostname: 'rabbitmq_server')
    connection = Bunny.new(hostname: 'rabbitmq', user: 'guest', password: 'guest')

    begin
      connection.start
      puts " Conexión a RabbitMQ establecida."

      # Crear un canal y declarar el exchange directo
      channel = connection.create_channel
      exchange = channel.direct('mi_exchange', durable: true)

      # Configurar la cola dinámica basada en el consumidor
      # nombre dinamicoi de la cola
      queue_name = "cola_#{consumidor}"
      routing_key = "customer#{consumidor}"
      queue = channel.queue(queue_name, durable: true)
      queue.bind(exchange, routing_key: routing_key)

      # Crear el mensaje JSON que contiene los productos
      mensaje = { productos: productos }.to_json

      # Mostrar el mensaje que se enviará
      puts " Enviando mensaje a RabbitMQ:"
      puts " JSON: #{mensaje}"
      puts " Publicando en la cola '#{queue_name}' con la clave de enrutamiento '#{routing_key}'."

      # Publicar el mensaje
      exchange.publish(mensaje, routing_key: routing_key, persistent: true)

      puts "Mensaje enviado correctamente a RabbitMQ."
      puts " Datos enviados: #{productos.inspect}"
    rescue Bunny::TCPConnectionFailedForAllHosts => e
      puts " Error de conexión con RabbitMQ: #{e.message}"
    rescue StandardError => e
      puts " Error al enviar el mensaje: #{e.message}"
    ensure
      # Cerrar la conexión
      connection.close if connection && connection.open?
      puts " Conexión a RabbitMQ cerrada."
    end
  end
end
