require "flood_risk_engine/configuration"
require "flood_risk_engine/exceptions"
require "activerecord/session_store"
require "high_voltage"
require "defra_ruby/area"
require "defra_ruby_email"
require "active_support/dependencies"
require_dependency "virtus"

module FloodRiskEngine
  class Engine < ::Rails::Engine
    isolate_namespace FloodRiskEngine

    # Add a load path for this specific Engine
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    initializer :add_i18n_load_paths do |app|
      app.config.i18n.load_path += Dir[config.root.join("config/locales/**/**/", "*.{rb,yml}").to_s]
    end

    # Automatically add our migrations into the main apps migrations
    initializer :append_migrations, before: :load_config_initializers do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer :application_Helper do |_app|
      ActiveSupport.on_load :action_controller do
        helper FloodRiskEngine::ApplicationHelper
      end
    end

    # Make Engine Factories available to Apps
    unless Rails.env.production?
      initializer "flood_risk_engine.factories", after: "factory_bot.set_factory_paths" do
        require "factory_bot"

        path = File.expand_path("../../../spec/factories", __FILE__)
        FactoryBot.definition_file_paths << path
      end
    end
  end
end
