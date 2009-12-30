class TagReader
  attr_accessor :output
  
  def read(path)
    python = AppConfig.python
    path = path.gsub(/['"\\\x0]/,'\\\\\0')
    self.output = `#{python} #{Rails.root}/lib/readtags.py '#{path}'`
    self
  end

  def tags
    tags = {}

    self.output.split("\n").each do |line|
      pair = line.split(':-:')
      tags[pair[0]] = pair[1]
    end

    tags
  end
end

#class TagReader
#  attr_accessor :output
#
#  def read(path)
#    path = path.gsub(/['"\\\x0]/,'\\\\\0')
#    self.output = `#{AppConfig.exiftool} -j '#{path}'`
#    self
#  end
#
#  def tags
#    tags = JSON.load(self.output)[0]
#    tags
#  end
#end