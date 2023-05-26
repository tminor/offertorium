require_relative 'boot'

require 'rails'

require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'active_model/railtie'

Bundler.require(*Rails.groups)

require 'dry/rails/railtie'

require 'rom'
require 'rom-rails'
require 'rom-repository'
require 'rom-sql'

require 'dry/monads/do'

module OffertoriumAPI
  class Application < Rails::Application
    config.load_defaults 7.0
    config.api_only = true

    require 'dry/validation'

    Dry::Validation.load_extensions(:monads)
  end
end
