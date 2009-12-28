require 'gst'

uri = "file:///home/leon/Music/02 Paranoid Android.mp3"
#uri = "file:///home/leon/Workspaces/pmpd/samples/gapless/ogg/04. Beethoven.ogg"
playbin = Gst::ElementFactory.make('playbin2')
playbin.uri = uri
playbin.ready

sink = Gst::ElementFactory.make("fakesink")
playbin.video_sink = sink
playbin.audio_sink = sink

#mainloop = GLib::MainLoop.new(nil, true)
#mainloop = GLib::MainLoop.new(GLib::MainContext.default, true)

#playbin = Gst::ElementFactory.make('filesrc')
#playbin.location = uri

playbin.bus.add_watch do |bus, message|
  case message.type
    when Gst::Message::TAG
      p message.parse
#      tag = message.parse_tag()
#      tag.each do |key,value|
#        if key != "name"
#          p "#{key} = #{value}"
#        end
#      end
  end
  true
end

#playbin.signal_connect 'deep_notify' do |obj, origin, pspec|
#  case pspec.name
#      when 'metadata'
#        p origin.metadata
#  when 'streaminfo'
#    p origin.streaminfo
#  end
#  true
#end

#Thread.new do #make this optional
#  Thread.abort_on_exception = true
#  Thread.critical = true

  loop = GLib::MainLoop.new(nil, true)
  playbin.pause
  loop.run
#end