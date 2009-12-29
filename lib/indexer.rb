require 'rubygems'
require 'rb-inotify'
require "#{Rails.root}/lib/filewatcher.rb"

class Indexer < FileWatcher
  def initialize()
    super(AppConfig.paths)
  end

  def new_dir(path)
    Rails.logger.debug("New dir #{path}")
    self.walk(path)
  end

  def deleted_dir(path)
    Rails.logger.debug("Deleted dir #{path}")
    Song.delete_all(['location Like ?', "'#{path}%'"])
  end

  def renamed_dir(from_path, to_path)
    Rails.logger.debug("Dir renamed from #{from_path} to #{to_path}")

    Song.find(:all, :conditions => ['location Like ?', "#{from_path}%"]).each do |song|
      song.location = song.location.gsub(/^#{from_path}/, to_path)
      song.save()
    end
  end

  def new_file(path)
    Rails.logger.debug("New file #{path}")
    song = Song.find_or_create_by_location(path)
    song.get_metadata()
    song.save()
  end

  def deleted_file(path)
    Rails.logger.debug("Deleted file #{path}")
    Song.delete_all(['location = ?', path])
  end

  def renamed_file(from_path, to_path)
    Rails.logger.debug("File renamed from #{from_path} to #{to_path}")
    song = Song.find_by_location(from_path)
    if song
      song.location = to_path
      song.save
    end
  end

  def walk(dir)
    locations = []
    ids = []

    dir = dir.gsub(/\/*$/, '')

    Dir["#{dir}/**/*.*"].each do |path|
      song = Song.find_or_create_by_location(path)
      locations << path
      ids << song.id

      if not song.metadata?
        song.get_metadata()
        song.save()
      end
    end

    if ids.length > 0
      Song.delete_all(['id NOT IN (?) AND location LIKE ?', ids, "#{dir}%"])
    end
  end

  def run()
    Rails.logger.info('Reading paths on startup')

    AppConfig.paths.each do |path|
      uri = URI::extract(path)

      if uri[0]
        next #url's are not supported yet
      end

      path = path.gsub(/\/*$/, '') #remove right slash
      path = File.expand_path(path)

      self.walk(path)
    end

    Rails.logger.info('Starting indexer')
    super
  end
end