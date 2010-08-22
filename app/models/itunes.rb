class Itunes
  States = { 1800426352 => :paused, 1800426320 => :playing, 1800426323 => :stopped}
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
    tracklist = bridge_block do
      if playerState == :stopped
        dj.tracks.map { |track| Track.new(track) }.to_a
      else
        tracklist = currentPlaylist.tracks.map { |track| Track.new(track) }.to_a
      end
    end
    tracklist.each(&:readonly!) unless currentPlaylist.name == dj.name
    return tracklist[1...10] unless [:playing, :paused].include?(playerState)
    offset = tracklist.index(currentTrack) + 1
    raise "No track #{currentTrack} in current playlist #{currentPlaylist.name}" unless offset
    tracklist[offset...offset + 10]
  end
  alias :play_queue :playQueue

  def playNext(track)
  end
  alias :play_next :playNext

  def playlists
    bridge_block do
      @itunes.sources[0].playlists
    end
  end

  def dj
    playlists.detect { |list| list.name == "iTunes DJ" }
  end

end

