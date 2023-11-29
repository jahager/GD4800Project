extends HBoxContainer

var song_name: String
var genres: String
var json
@onready var playlist_label = $PanelContainer/VBoxContainer/HBoxContainer/BoxContainer/HBoxContainer/PlaylistLabel
@onready var song_v_box_container = $PanelContainer/VBoxContainer/VBoxContainer
@onready var add_song_search_text_edit = $ConfirmationDialog/CenterContainer/TextEdit


# Create GUI list of songs/album images
func add_json(json, song_name, genres):
	self.song_name = song_name
	self.genres = genres
	self.json = json
	
	var song_header_label = "Song: " + song_name 
	# Add Genres
	if genres.length() > 0 :
		song_header_label = song_header_label +  ", Genres: " + genres
	set_playlist_title(song_header_label)
	
	for recomendation in json:
		var song_row = preload("res://Scenes/single_song_display.tscn").instantiate()
		self.song_v_box_container.add_child(song_row)
		song_row.set_song(recomendation)

func set_playlist_title(title: String):
	self.playlist_label.text = title
			
func free_self():
	var whale_delete = preload("res://Scenes/whale_eat.tscn").instantiate()
	whale_delete.delete_this(self)

func get_playlist_json():
	var playlist: Dictionary = {}
	playlist["song"] = self.song_name
	playlist["genres"] = self.genres
	playlist["playlist"] = json
	
	# Convert to JSON
	var json_string = JSON.stringify(playlist)
	var parse_attempt = JSON.parse_string(json_string)
	return parse_attempt.result

func import_from_saved_json(saved_json):
	song_name = saved_json["song"]
	genres = saved_json["genres"]
	json = saved_json["playlist"]
	self.add_json(json, song_name, genres)


func _on_add_song_button_pressed():
	$ConfirmationDialog.popup_centered()
	self.add_song_search_text_edit.grab_focus()


func _on_text_edit_gui_input(event):
	# Remove newline and lazer button on ENTER
	if event is InputEventKey and event.key_label == KEY_ENTER and event.is_pressed():
		# Search 
		_on_confirmation_dialog_confirmed()
	
	if event is InputEventKey and event.key_label == KEY_ENTER:
		# Remove new line
		self.add_song_search_text_edit.text = self.add_song_search_text_edit.text.strip_escapes()


func _on_confirmation_dialog_confirmed():
	$ConfirmationDialog.hide()
	var url: String = "https://pmrapim.azure-api.net/personal-music-recommendation/search?q=" + self.add_song_search_text_edit.text.uri_encode()
	url += "&type=track&limit=1"
	print(url)
	$HTTPRequest.request(url)
	
	#remove song text
	self.add_song_search_text_edit.text = ""


func _on_http_request_request_completed(result, response_code, headers, body):
	# Act on success only
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		for recomendation in json:
			var song_row = preload("res://Scenes/single_song_display.tscn").instantiate()
			self.song_v_box_container.add_child(song_row)
			song_row.set_song(recomendation)
			self.song_v_box_container.move_child(song_row, 0)
			turn_visible(song_row)
	
	# Notify user of web error
	else:
		var error_popup = AcceptDialog.new()
		error_popup.dialog_text = "Error Web Response: " 
		str(response_code)
		add_child(error_popup)
		error_popup.popup_centered()

func turn_visible(old_control: Control, reduction_time = 1):
	old_control.modulate.a = 0
	var reduce_size_tween = create_tween()
	reduce_size_tween.parallel().tween_property(old_control, "modulate:a", 1, reduction_time)
	reduce_size_tween.play()
	
func add_song_json_to_json(new_json):
	# Convert to JSON
#	var json_string = JSON.stringify(playlist)
	var parse_attempt = JSON.parse_string(new_json)
	var new_json_parsed = parse_attempt.result
	var old_json_parsed = JSON.parse_string(self.json).result
	new_json_parsed.append(new_json)
	self.json = old_json_parsed.stringify()
	

