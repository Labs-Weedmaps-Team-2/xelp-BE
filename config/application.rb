require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Xelp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # Loads environmental variables defined in /config/local_env.yml
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    # CORS configuration
    # Master (deployed), Development (deployed), Development(local)
    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins ['https://goofy-edison-2eb1f5.netlify.com','https://pensive-mclean-75bb36.netlify.com','http://localhost:4000']
    #     resource '*',
    #       credentials: true,
    #       headers: :any,
    #       methods: [:get, :post, :put, :patch, :delete, :options]
    #   end
    # end

        # CORS configuration
    config.middleware.insert_before 0, Rack::Cors, :debug => true, :logger => (-> { Rails.logger }) do
      # Local development frontend
      allow do
        origins 'http://localhost:4000'
        resource '*',
          credentials: true,
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options]
      end
      # Deployed staging frontend (development branch on GitHub)
      allow do
        origins 'https://night-lyfe.netlify.com'
        resource '*', 
          credentials: true,
          headers: :any, 
          methods: [:get, :post, :put, :patch, :delete, :options]
      end
      # Deployed production frontend (master branch on GitHub)
      allow do
        origins 'https://goofy-edison-2eb1f5.netlify.com'
        resource '*',
          credentials: true,
          headers: :any, 
          methods: [:get, :post, :put, :patch, :delete, :options]
      end
      allow do
        origins 'https://pensive-mirzakhani-239468.netlify.com/business-list'
        resource '*',
          credentials: true,
          headers: :any, 
          methods: [:get, :post, :put, :patch, :delete, :options]
      end
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
