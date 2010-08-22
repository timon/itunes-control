// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function update_albums() {
  $('#select_album').html(window.albums);
  var selected = $($("#select_artist").val());
  var options = $('#select_album option');
  var missing = [];
  options.each(function(idx, el) {
    var good = $(el).val() == "all_albums";
    selected.each(function(c_i, klass) { if ($(el).hasClass(klass)) good = true; });
    if (!good) missing.push(el);
  });
  $(missing).remove();
  $('#library tbody tr').hide();
  selected.each(function(i, klass) { $('#library tr.' + klass).show()});
}

function update_tracks() {
  selected_artists = $($("#select_artist").val());
  selected_albums  = $($("#select_album").val());

  if (selected_albums.length == 0 || $.makeArray(selected_albums).indexOf('all_albums') != -1) {
    update_albums();
    return;
  }
  var missing = [];
  $('#library tbody tr').hide();
  selected_albums.each(function(i, klass) { $('#library tr.' + klass).show()});
}

function newQueue(xhr) {
  $('#upcoming').replaceWith(xhr.responseText);
  $('a').attach(Remote.Link, { complete: newQueue })
}

function updateSong() {
  $.get('/songs/current', function(data) { $('#current_song').html(data); });
  $.get('/', function(data) { $('#upcoming').replace(data); $('#upcoming a').attach(Remote.Link, { complete: newQueue}); });
}

jQuery(function($) {
  window.albums = $($('#select_album').html());
  $('#select_artist').change(update_albums);
  $('#select_album').change(update_tracks);
  $('a').attach(Remote.Link, { complete: newQueue })
  setInterval(updateSong, 3000);
});

