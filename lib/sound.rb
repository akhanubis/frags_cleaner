module FragsCleaner
  module Sound
    SDL.init(SDL::INIT_AUDIO)
    SDL::Mixer.open(44100, SDL::Mixer::DEFAULT_FORMAT, 2, 1024)
    @success = SDL::Mixer::Wave.load("assets\\success.wav")
    @failure = SDL::Mixer::Wave.load("assets\\failure.wav")

    class << self
      def play_alert(status)
        SDL::Mixer.set_volume(-1, Config.volume)
        SDL::Mixer.play_channel(-1, status ? @success : @failure, 0)
      end
    end
  end
end