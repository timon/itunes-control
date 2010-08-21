class Itunes
  State = { 1800426352 => :paused, 1800426320 => :playing, 1800426323 => :stopped}
  include Singleton
  def initialize
    @itunes =  OSX::SBApplication.applicationWithBundleIdentifier("com.apple.iTunes")
    @updated_at = nil
  end

  def method_missing(method, *args)
    @itunes.send method, *args
  end

  def currentTrack
    Track.new(@itunes.currentTrack)
  end
  alias :current_track :currentTrack

  def library
    @library ||= Library.new(@itunes)
  end

  def artists
    library.artists
  end

  def albums
    library.albums
  end

  def playerState
    States[@itunes.playerState] || :unknown
  end
  alias :player_state playerState

  def playQueue
    tracklist = []
    begin
      retries = 0
      tracklist = currentPlaylist.tracks.map { |track| Track.new(track) }.to_a
    rescue => e
      raise e if retries > 0
      retries += 1
      retry
    end
    offset = tracklist.index(currentTrack)
    raise "No track #{currentTrack} in current playlist #{currentPlaylist.name}" unless offset
    tracklist[offset..offset + 10]
  end

  alias :play_queue :playQueue
end

class Object
  def iTunes
    self.class.iTunes
  end
  def self.iTunes
    Itunes.instance
  end
end

