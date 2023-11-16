extends HBoxContainer

var song_name: String
var genres: String
var json: JSON

# Create GUI list of songs/album images
func add_json(json, song_name, genres):
	self.song_name = song_name
	self.genres = genres
	self.json = json
	
	var panel = PanelContainer.new()
	
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	self.add_child(panel)
	panel.custom_minimum_size.x = 600
	
	var vbox = VBoxContainer.new()
	vbox.mouse_filter = Control.MOUSE_FILTER_PASS
	panel.add_child(vbox)
	
	var header = BoxContainer.new()
	header.alignment = BoxContainer.ALIGNMENT_END
	header.mouse_filter = Control.MOUSE_FILTER_PASS
	vbox.add_child(header)
	
	var header_hbox = HBoxContainer.new()
	header.add_child(header_hbox)
	
	var song_header_label = Label.new()
	# Add song name
	song_header_label.text = "Song: " + song_name 
	# Add Genres
	if 0 < genres.length():
		song_header_label.text = song_header_label.text +  ", Genres:" + genres
	header_hbox.add_child(song_header_label)
	var label_settings = LabelSettings.new()
	label_settings.font_size = 20
	song_header_label.label_settings = label_settings
	
	
	var delete_button = Button.new()
	delete_button.text = "Delete List"
	delete_button.connect("pressed", free_self)
	header_hbox.add_child(delete_button)
	
	for recomendation in json:
		var song_row = preload("res://Scenes/single_song_display.tscn").instantiate()
		vbox.add_child(song_row)
		song_row.set_song(recomendation)

			
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
