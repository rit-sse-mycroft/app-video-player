require 'mycroft'

class VideoPlayer < Mycroft::Client

  attr_accessor :verified

  def initialize
    @key = ''
    @cert = ''
    @manifest = './app.json'
    @verified = false
  end

  def connect
    # Your code here
  end

  def on_data(parsed)
    if parsed[:type] == 'APP_DEPENDENCY'
      up
    elsif parsed[:type] == "MSG_QUERY" and parsed[:type]['action'] == 'start_stream'
      data = parsed[:data]['data']
      `vlc rtsp://#{data['host']}:#{data['port']}`
    end
  end

  def on_end
    # Your code here
  end
end

Mycroft.start(VideoPlayer)
