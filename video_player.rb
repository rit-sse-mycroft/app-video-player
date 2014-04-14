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
    #@threaded = true
    super
  end
  
  on 'CONNECT' do 
    puts 'Connected!'
    Thread.new do
      loop do
        if @status=='playing'
          if (!@vlc.playing?)
            puts "Stopped playing, setting status to UP"
            @status = 'stopped'
            up
          end
        end
      end
    end
  end

  on 'APP_MANIFEST_OK' do |data|
    puts "Going up!"
    up
  end

  on 'MSG_QUERY' do |data|
    if data['action'] == 'video_stream'
      if (!@vlc.playing?)
        puts "Starting the video!"
        Thread.new do
          sleep 15 # Give the video a few seconds to start
          @status = 'playing'
        end
        in_use(30)
        data = data['data']['url']
        @vlc.play(data)
      end
    elsif data['action'] == 'halt'
      puts "Stopping video"
      @vlc.stop
      @status = "stopped"
      up
    end
  end
end

Mycroft::start(VideoPlayer)
