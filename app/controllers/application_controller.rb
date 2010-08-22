# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :prepare

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def now_playing
    load_upcoming
    @track = @iTunes.currentTrack
    @position = @iTunes.playerPosition.seconds
    respond_to do |wants|
      wants.html
      wants.js { render :partial => "tracks", :object => @iTunes.play_queue, :locals => { :id => "upcoming"} }
    end
  end

  def play
    @iTunes = Itunes.instance
    track = @iTunes.play_queue.detect { |song| song.databaseID == @song_id }
    track = @iTunes.library.trackWithID(@song_id).playNextInDJ unless track
    track.playOnce(false)
    sleep(0.01)
    respond
  end

  def remove
    @iTunes = Itunes.instance
    track = @iTunes.dj.tracks.detect { |song| song.databaseID == @song_id }
    if track
      current = (track == @iTunes.currentTrack)
      @iTunes.dj.tracks.removeObject(track)
      @iTunes.dj.tracks.first.playOnce(false) if current
    end
    respond
  end

  def make_next
    @iTunes.library.trackWithID(@song_id).playNextInDJ
    respond
  end

  def append
    @iTunes.library.trackWithID(@song_id).duplicateTo(@iTunes.dj)
    respond
  end

  def current
    @track = @iTunes.currentTrack
    render :partial => "current_song"
  end

  protected
  def prepare
    @iTunes = Itunes.instance
    @song_id = params[:id].to_i if params[:id]
  end

  def respond
    if request.xhr?
      load_upcoming
      render :partial => "tracks", :object => @upcoming, :locals => { :id => :upcoming }
    else
      respond_to do |wants|
        wants.html { redirect_to root_path }
        wants.js   { load_upcoming; render :partial => "tracks", :object => @upcoming, :locals => { :id => :upcoming } }
      end
    end
  end

  def load_upcoming
    @upcoming = @iTunes.playQueue
    if @iTunes.currentPlaylist.name == @iTunes.dj.name || [:stopped, :unknown].include?(@iTunes.playerState)
      @upcoming_actions = [:play, :remove]
      @library_actions  = [:play, :make_next, :append]
    else
      @upcoming_actions = [:play]
      @library_actions  = [:play]
    end
  end
end

