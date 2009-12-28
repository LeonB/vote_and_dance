#http://github.com/nex3/rb-inotify
#http://github.com/costan/daemonz/

require 'gst'
require 'inotify'

class Indexer
  def self.start()
    i = Indexer.new()
    
    AppConfig.paths.each do |path|
      AppConfig.paths.each do |path|
        uri = URI::extract(path)

        if uri[0]
          next #url's are not supported yet
        end

        path = File.expand_path(path)

        i.walk(path)
      end
    end

    i.watch()
  end

  def watch
    inotify_watches = {}
    incoming_notifier = Inotify.new
    outgoing_notifier = Inotify.new

    t1 = Thread.new do
      incoming_notifier.each_event do |event|
        path = inotify_watches[event.wd]
        location = "#{path}/#{event.name}"
        song = Song.find_or_create_by_location(location)
        song.get_metadata()
        song.save()
      end
    end

    t2 = Thread.new do
      outgoing_notifier.each_event do |event|
        path = inotify_watches[event.wd]
        location = "#{path}/#{event.name}"
        songs = Song.find_by_location(location)

        if songs
          songs.delete
        end
      end
    end

    AppConfig.paths.each do |path|
      uri = URI::extract(path)

      if uri[0]
        next #url's are not supported yet
      end

      path = File.expand_path(path)
#      location = "#{event.watcher.path}/#{event.name}"
      
      wd = incoming_notifier.add_watch(path, Inotify::CREATE | Inotify::MODIFY | Inotify::MOVED_TO)
      inotify_watches[wd] = path
      wd = outgoing_notifier.add_watch(path, Inotify::DELETE | Inotify::MOVED_FROM)
      inotify_watches[wd] = path

    end
      t1.join()
      t2.join()
  end

  def walk(dir)
    locations = []
    
    Dir["#{dir}**/*.*"].each do |path|
      song = Song.find_or_create_by_location(path)
      locations << path

      if not song.metadata?
        song.get_metadata()
        song.save()
      end
    end

    Song.delete_all(['location NOT IN (?)', locations])
  end
end