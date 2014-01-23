require 'mycroft'
require 'vlc-client'

class VideoPlayer < Mycroft::Client

  attr_accessor :verified

  def initialize(host, port)
    @key = ''
    @cert = ''
    @manifest = './app.json'
    @verified = false
    @vlc = VLC::System.new(fullscreen: true)
    @status = 'stopped'
    @threaded = true
    super
  end

  def connect
      Thread.new do
        loop do
          if @status=='playing'
            if (!@vlc.playing?)
              @status = 'stopped'
              up
            end
          end
        end
      end
  end
  
  def on_event_loop

  end

  def on_data(parsed)
    if parsed[:type] == 'APP_DEPENDENCY'
     # meh
    elsif parsed[:type] == 'APP_MANIFEST_OK'
      puts "Going up!"
      up
    elsif parsed[:type] == "MSG_QUERY" and parsed[:data]['action'] == 'video_stream'
      if (!@vlc.playing?)
        puts "Starting the video!"
        Thread.new do
          sleep 5 # Give the video a few seconds to start
          @status = 'playing'
        end
        in_use(30)
        data = parsed[:data]['data']['url']
        @vlc.play(data)
      end
    elsif parsed[:type] == "MSG_QUERY" and parsed[:data]['action'] == 'halt'
      if (@vlc.playing?)
        @vlc.stop
        @status = 'stopped'
        up
      end
    end
  end

  def on_end

  end
end

Mycroft.start(VideoPlayer)

while true

end