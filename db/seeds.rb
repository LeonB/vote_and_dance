# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Playlist.create({:name => 'Default', :default => true})

AppConfig.paths.each do |path|
  uri = URI::extract(path)

  if uri[0]
    next #url's are not supported yet
  end

  path = path.gsub(/\/*$/, '') #remove right slash
  path = File.expand_path(path)

  Indexer.new.walk(path)
end

User.create({:email => 'leon@tim-online.nl', :password => 'test',
    :password_confirmation => 'test'})
User.create({:email => 'test@tim-online.nl', :password => 'test',
    :password_confirmation => 'test'})