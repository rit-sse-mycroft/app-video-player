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
    super
  end

  def connect
    # Your code here
  end
  
  def on_event_loop
    if @status=='playing'
      if (!vlc.playing?)
        @status = 'stopped'
        up
      end
    end
  end

  def on_data(parsed)
    if parsed[:type] == 'APP_DEPENDENCY'
      up
    elsif parsed[:type] == "MSG_QUERY" and parsed[:type]['action'] == 'stream'
      if (!vlc.playing?)
        @status = 'playing'
        in_use
        data = parsed[:data]['data']
        @vlc.play(data)
      end
    elsif parsed[:type] == "MSG_QUERY" and parsed[:type]['action'] == 'halt'
      if (vlc.playing?)
        @vlc.stop
        @status = 'stopped'
        up
      end
    end
  end

  def on_end
    # Your code here
  end
end

Mycroft.start(VideoPlayer)
