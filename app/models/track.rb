class Track
  attr_reader :track
  def initialize(iTunesTrack)
    @track = iTunesTrack
  end

  def database_id
    @id ||= @track.databaseID
  end
  alias :id :database_id
  alias :databaseID :database_id

  def artist
    @artist ||= [@track.artist, "Unknown artist"].detect(&:present?).to_s
  end

  def compilation?
    @compilation.nil? && @compilation = @track.compilation?
    @compilation
  end

  def album_artist
    (compilation? ? "Various Artists" : artist).to_s
  end

  def album
    if @album.blank?
      @album = [@track.album, "Unknown album"].detect(&:present?).to_s
      @album << ", #{year}" if year.present? && year > 0
    end
    @album
  end

  def year
    @year ||= @track.year
  end

  def name
    @name ||= @track.name
  end

  def trackNumber
    @trackNumber ||= @track.trackNumber
  end

  def discNumber
    @discNumber ||= @track.discNumber
  end

  def to_s
    "%s — %s (%s)" % [artist, name, album]
  end

  def inspect
    "<Track: 0x%x %s>" % [object_id, to_s]
  end

  def readonly!
    @readonly = true
  end

  def readonly?
    @readonly
  end

  def play
    @track.playOnce(false)
  end

  def playNextInDJ
    iTunes = Itunes.instance
    currentTracks = iTunes.dj.tracks.to_a.map { |t| Track.new(t) }
    if iTunes.currentPlaylist.name == iTunes.dj.name && iTunes.currentTrack.name
      currentPosition = currentTracks.index(iTunes.currentTrack)
      currentTracks.shift currentPosition.succ if currentPosition
    end
    new_track = self.duplicateTo(iTunes.dj)
    currentTracks.each { |t| t.duplicateTo iTunes.dj }
    iTunes.dj.tracks.removeObjectsInRange OSX::NSMakeRange(currentPosition.succ, currentTracks.length) if currentPosition
    new_track
  end

  def method_missing(method, *args)
    @track.send method, *args
  end

  def <=>(other)
    #--------------------------------------------------
    # [:album_artist, :year, :album, :discNumber, :trackNumber].each do |attr|
    #   diff = (self.send(attr) <=> other.send(attr))
    #   return diff unless diff == 0
    # end
    #-------------------------------------------------- 
    diff = album_artist <=> other.album_artist
    return diff unless diff == 0
    diff = year <=> other.year
    return diff unless diff == 0
    diff = album <=> other.album
    return diff unless diff == 0
    diff = discNumber <=> other.discNumber
    return diff unless diff == 0
    diff = trackNumber <=> other.trackNumber
    return diff unless diff == 0

    return name <=> other.name
  end

  def ==(other)
    other.is_a?(Track) && other.id == self.id
  end
end

