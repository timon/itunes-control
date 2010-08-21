class Library
  attr_reader :library
  def initialize(iTunes)
    @library = iTunes.sources[0].playlists[0]
    @updated_at = nil
  end

  def method_missing(method, *args)
    @library.send method, *args
  end

  def tracks
    reload_browser!
    @tracks
  end

  def albums
    reload_browser!
    @albums
  end

  def artists
    reload_browser!
    @artists
  end

  def album_artists
    reload_browser!
    @album_artists
  end

  def album_artist(album_name)
    album_name = album_name.to_s
    @tracks.detect { |lib_track| lib_track.album == album_name }.album_artist.to_s
  end

  protected
  def reload_browser!
    return unless @updated_at.nil? || @updated_at < 5.minutes.ago
    @retry_count = 0
    begin
      @tracks = @library.tracks.map { |track| Track.new(track) }.sort
      @artists = @tracks.map(&:artist).sort.uniq
      @albums = @tracks.map(&:album).sort.uniq
      @album_artists = @tracks.map(&:album_artist).sort.uniq
      @updated_at = Time.now
    rescue => e
      if @retry_count < 1
        @retry_count += 1
        retry
      else
        raise e
      end
    end
  end
end

