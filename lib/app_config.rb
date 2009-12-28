# Load application configuration
require 'ostruct'
require 'yaml'

config = YAML.load_file("#{Rails.root}/config/config.yml") || {}
config.update(config[Rails.env] || {})
AppConfig = OpenStruct.new(config)