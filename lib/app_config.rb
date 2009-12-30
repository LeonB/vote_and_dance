# Load application configuration
require 'ostruct'
require 'yaml'

config = YAML.load_file("#{Rails.root}/config/config.yml") || {}
config.update(config[Rails.env] || {})
AppConfig = OpenStruct.new(config)

AppConfig.accepted_extensions.each do |extension|
  extension.gsub!(/^\./, '')
end

if AppConfig.pyton.nil?
  AppConfig.python = `which python`.strip()
end