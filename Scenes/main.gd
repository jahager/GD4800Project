extends Node
var NO_GENRE = "Optional Genre Select"
var genres = ["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova", "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country", "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep", "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore", "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk", "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop", "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age", "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house", "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance", "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish", "study", "summer", "swedish", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music"]
var genre_popup

func _ready():
	genre_popup = $GenreMenuButton.get_popup()
	genre_popup.connect("id_pressed", add_genre)
	for gen in genres:
		genre_popup.add_item(gen)

func add_genre(id):
	var genre = preload("res://Scenes/genre_item.tscn").instantiate()
	genre.set_text(genres[id])
	$GenreHFlowContainer.add_child(genre)

# Get web content
func _on_search_button_pressed():
	var url: String = "https://personal-music-recommendation.azurewebsites.net/api/recommendation?code=BiLtlWfdvS4NmIH_Y9_xDnCT1Cs5rOLoLWvenK88PQW8AzFuDX25TA==&song=" + $TextEdit.text.uri_encode()
	url += "&genre=" + get_genres().uri_encode()
	print(url)
	$HTTPRequest.request(url)
	
func get_genres():
	var genres = ""
	for genre_item in $GenreHFlowContainer.get_children():
		genres = genres + genre_item.get_text() + ","
	return genres

# Add song content to scroll area
func add_songs(song_json):
	var song_list = preload("res://Scenes/list_of_songs.tscn").instantiate()
	$ScrollContainer.find_child("VBoxContainer").add_child(song_list)
	song_list.add_json(song_json)

# Handle web content
func _on_http_request_request_completed(result, response_code, headers, body):
	# Act on success only
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		add_songs(json)
	
	# Notify user of web error
	else:
		var error_popup = AcceptDialog.new()
		error_popup.dialog_text = "Error Web Response: " 
		str(response_code)
		add_child(error_popup)
		error_popup.popup_centered()

# Act on enter key.
func _on_text_edit_gui_input(event):
	if event is InputEventKey and event.key_label == KEY_ENTER:
		# Remove new line
		$TextEdit.text = $TextEdit.text.strip_escapes()
		# Search 
		_on_search_button_pressed()
