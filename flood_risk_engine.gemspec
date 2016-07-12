# rubocop:disable Metrics/LineLength
$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flood_risk_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flood_risk_engine"
  s.version     = FloodRiskEngine::VERSION
  s.authors     = ["Digital Services Team, EnvironmentAgency"]
  s.email       = ["dst@environment-agency.gov.uk"]
  s.homepage    = "https://github.com/EnvironmentAgency/flood-risk-engine"
  s.summary     = "FloodRiskEngine package containing core elements and functionality"
  s.description = "FloodRiskEngine package containing core elements and functionality"
  s.license     = "The Open Government Licence (OGL) Version 3"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.2"
  s.add_dependency "reform", "2.1.0" # Form object convenience - fixing this version as later versions cause issues
  s.add_dependency "reform-rails", "0.1.0" # Form object convenience - fixing this version as later versions cause issues
  s.add_dependency "dotenv-rails", "~> 2.1"
  s.add_dependency "finite_machine", "~> 0.10"
  s.add_dependency "dibber", "~> 0.5" # Manages data seeding
  s.add_dependency "jquery-rails", ">= 3.1"
  s.add_dependency "validates_email_format_of", "~> 1.6" # Validate e-mail addresses against RFC 2822 and RFC 3696
  s.add_dependency "phonelib", "~> 0.6" # Add telephone number validation
  s.add_dependency "activerecord-session_store", "~> 1.0"
  s.add_dependency "os_map_ref", "~> 0.4"
  s.add_dependency "has_secure_token", "~> 1.0.0" # Enables url obfuscation with 24bit base58 token
  s.add_dependency "uk_postcode", "~> 2.1" # Postcode format validation
  s.add_dependency "high_voltage", "~> 3.0" # Rails engine for static pages. https://github.com/thoughtbot/high_voltage
  s.add_dependency "virtus", "~> 1.0"
  s.add_dependency "ea-address_lookup", "~> 0.3.0"
  s.add_dependency "ea-area_lookup", "~> 0.1.1"

  s.add_dependency "airbrake-ruby", "~> 1.3.2"
  s.add_dependency "airbrake", "~> 5.3.0" # Airbrake catches exceptions, sends them to https://dst-errbit.xxx.co.uk
  s.add_dependency "nokogiri", ">= 1.6.8" # Used by other gems - but need to force version due to CVE-2015-8806
  s.add_dependency "sucker_punch", "~> 2.0.2" # ActiveJob background processing using another thread

  s.add_development_dependency "pg", "~> 0.18"
  s.add_development_dependency "before_commit", "~> 0.6"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "bootstrap-sass", "~> 3.3"
  s.add_development_dependency "sass-rails", ">= 3.2"
  s.add_development_dependency "quiet_assets", "~> 1.1"
  s.add_development_dependency "byebug", "~> 8.2"
  s.add_development_dependency "puma", "~> 3.4"
end
