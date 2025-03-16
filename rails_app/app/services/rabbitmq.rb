# require 'bunny'

# module RabbitMQ
#   def self.connection
#     # @connection ||= Bunny.new(hostname: 'localhost').tap(&:start)
#     @connection ||= Bunny.new(hostname: 'rabbitmq_server').tap(&:start)

#   end

#   def self.channel
#     @channel ||= connection.create_channel
#   end
# end
# services/rabbitmq.rb
require 'bunny'

class RabbitMQ
  def self.connection
    @connection ||= Bunny.new(hostname: 'rabbitmq') # Asegúrate de que el nombre coincide con el contenedor de RabbitMQ
    @connection.start
    @connection
  end

  def self.channel
    @channel ||= connection.create_channel
  end
end
