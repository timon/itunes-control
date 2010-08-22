ActionController::Routing::Routes.draw do |map|
  [:play, :remove, :make_next, :append].each do |action|
    map.named_route "#{action}_song", "/songs/:id/#{action}", :controller => :application, :action => action
  end
  map.current_song '/songs/current', :controller => :application, :action => :current
  map.root :controller => :application, :action => :now_playing
end

