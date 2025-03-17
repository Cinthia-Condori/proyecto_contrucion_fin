require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShopCenter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Asegurar que Rails cargue los archivos de `app/services/`
    config.autoload_paths << Rails.root.join('app/services')

    # Configuración para Active Record
    config.active_record.async_query_executor = :global_thread_pool
  end
end
