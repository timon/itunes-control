class Track
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

