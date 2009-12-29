class FileWatcher
  attr_accessor :notifier, :recursive, :paths

  def initialize(paths, recursive = true)
    self.notifier = INotify::Notifier.new()
    self.recursive = recursive

    if not paths.is_a?(Array)
      self.paths = [paths]
    else
      self.paths = paths
    end

    if self.recursive
      self.recursive_watch(self.paths)
    else
      self.watch(self.paths)
    end
  end

  def paths=(paths)
    @paths = []
    paths.each do |path|
      uri = URI::extract(path)

      if uri[0]
        next #url's are not supported yet
      end

      path = path.gsub(/\/*$/, '') #remove right slash

      path = File.expand_path(path)
      @paths << path
    end
  end

  def run()
    return self.notifier.run()
  end

  protected
  def watch(paths)
    paths.each do |path|
      self.notifier.watch(path, :all_events) do |event|
        self.handle_event(event)
      end
    end
  end

  def recursive_watch(paths)
    self.watch(paths)

    paths.each do |path|
      Dir["#{path}/**"].each do |p|
        if File.directory?(p)
          self.recursive_watch([p])
        end
      end
    end
  end

  def delete_watcher(path)
#    self.notifier.watchers.each do |key, watcher|
#      if watcher.path == path
#        self.notifier.watchers.delete(key)
#      end
#    end
  end

  def handle_event(event)
    location = "#{event.watcher.path}/#{event.name}"

    if event.related.length > 0
      to_event = event.related[0]
      to_location = "#{to_event.watcher.path}/#{to_event.name}"

      if event.flags.include?(:isdir)
        return self._renamed_dir(location, to_location) if event.flags.include?(:moved_from)
      else
        return self._renamed_file(location, to_location) if event.flags.include?(:moved_from)
      end

      return if event.flags.include?(:moved_to)
    end

    if event.flags.include?(:isdir)
      return self._new_dir(location) if event.flags.include?(:create)
      return self._new_dir(location) if event.flags.include?(:modify)
      return self._new_dir(location) if event.flags.include?(:moved_to)

      return self._deleted_dir(location) if event.flags.include?(:delete)
      return self._deleted_dir(location) if event.flags.include?(:moved_from)
    else
      return self._new_file(location) if event.flags.include?(:create)
      return self._new_file(location) if event.flags.include?(:modify)
      return self._new_file(location) if event.flags.include?(:moved_to)

      return self._deleted_file(location) if event.flags.include?(:delete)
      return self._deleted_file(location) if event.flags.include?(:moved_from)
    end
  end

  def _new_dir(path)
    self.new_dir(path) if self.respond_to?(:new_dir)
    if self.recursive
      self.recursive_watch([path])
    end
  end

  def _deleted_dir(path)
    self.deleted_dir(path) if self.respond_to?(:deleted_dir)
    if self.recursive
      self.delete_watcher(path)
    end
  end

  def _renamed_dir(from_path, to_path)
    self.renamed_dir(from_path, to_path) if self.respond_to?(:renamed_dir)
    if self.recursive
      self.recursive_watch([to_path])
      self.delete_watcher(from_path)
    end
  end

  def _new_file(path)
    self.new_file(path) if self.respond_to?(:new_file)
  end

  def _deleted_file(path)
    self.deleted_file(path) if self.respond_to?(:deleted_file)
  end

  def _renamed_file(from_path, to_path)
    self.renamed_file(from_path, to_path) if self.respond_to?(:renamed_file)
  end
end