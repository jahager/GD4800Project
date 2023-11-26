extends Node
var NO_GENRE = "Optional Genre Select"
var genres = ["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova", "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country", "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep", "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore", "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk", "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop", "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age", "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house", "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance", "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish", "study", "summer", "swedish", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music"]
var genre_popup
var eye_position = Vector2(96,78)



func _ready():
	genre_popup = $GenreMenuButton.get_popup()
	genre_popup.connect("id_pressed", add_genre)
	for gen in genres:
		genre_popup.add_item(gen)
		


func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		$Lazer.shoot(eye_position, event.position)

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
	var genre_list = ""
	
	if 0 == $GenreHFlowContainer.get_child_count():
		return genre_list
	for genre_item in $GenreHFlowContainer.get_children():
		# Only add text for genre items
		if "Genre" in genre_item.get_meta("name", "ElseIgnoreIt"):
			genre_list += genre_item.get_text() + ","
	
	return genre_list.substr(0, genre_list.length() - 1)


# Add song content to scroll area
func add_songs(song_json):
	var song_list = preload("res://Scenes/list_of_songs.tscn").instantiate()
	var songs_container = $ScrollContainer.find_child("VBoxContainer")
	songs_container.add_child(song_list)
	# Add to gui
	song_list.add_json(song_json, $TextEdit.text, get_genres())
	# Move to top
	songs_container.move_child(song_list, 0)
	
	turn_visible(song_list, 0.7)

func turn_visible(old_control: Control, reduction_time = 1):
	old_control.modulate.a = 0
	var reduce_size_tween = create_tween()
	reduce_size_tween.parallel().tween_property(old_control, "modulate:a", 1, reduction_time)
	reduce_size_tween.play()
	
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
	
	# Lazer on typing
	if event is InputEventKey and event.is_pressed() and event.key_label != KEY_ENTER and event.key_label != KEY_SHIFT:
		# Shoot lazer from eye of unicorn
		var entry_letter_pos_x = $TextEdit.position.x + $TextEdit.get_caret_draw_pos().x
		var entry_letter_pos_y = $TextEdit.position.y + ($TextEdit.size.y / 2 )
		$Lazer.shoot(eye_position, Vector2(entry_letter_pos_x, entry_letter_pos_y))
	
	# Remove newline and lazer button on ENTER
	if event is InputEventKey and event.key_label == KEY_ENTER and event.is_pressed():
		# Shoot Lazer at reccomend button
		var button_pos_x = $SearchButton.position.x + ($SearchButton.size.x / 2)
		var button_pos_y = $SearchButton.position.y + ($SearchButton.size.y / 2 )
		$Lazer.shoot(eye_position, Vector2(button_pos_x, button_pos_y))
		# Search 
		_on_search_button_pressed()
	
	if event is InputEventKey and event.key_label == KEY_ENTER:
		# Remove new line
		$TextEdit.text = $TextEdit.text.strip_escapes()
