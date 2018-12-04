require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Hairfolio
  class Application < Rails::Application
    #config.load_defaults 5.2
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
        #cors configuration
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    config.eager_load_paths << Rails.root.join('lib')

    config.assets.initialize_on_precompile = false

    config.autoload_paths << Rails.root.join('lib')

    config.exceptions_app = self.routes

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
