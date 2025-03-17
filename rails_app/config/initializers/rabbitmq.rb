require 'bunny'

module RabbitMQ
  def self.connection
    @connection ||= Bunny.new(hostname: 'localhost').tap(&:start)
  end

  def self.channel
    @channel ||= connection.create_channel
  end
end
