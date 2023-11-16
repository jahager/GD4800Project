extends HBoxContainer

# Create GUI list of songs/album images
func add_json(json, song_name):
	
	
	var panel = PanelContainer.new()
	
	panel.mouse_filter = Control.MOUSE_FILTER_PASS
	self.add_child(panel)
	panel.custom_minimum_size.x = 600
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var header = BoxContainer.new()
	header.alignment = BoxContainer.ALIGNMENT_END
	vbox.add_child(header)
	
	var header_hbox = HBoxContainer.new()
	header.add_child(header_hbox)
	
	var song_header_label = Label.new()
	song_header_label.text = song_name
	header_hbox.add_child(song_header_label)
	
	var delete_button = Button.new()
	delete_button.text = "X"
	delete_button.connect("pressed", free_self)
	header_hbox.add_child(delete_button)
	
	for recomendation in json:
		var song_row = preload("res://Scenes/single_song_display.tscn").instantiate()
		vbox.add_child(song_row)
		song_row.set_song(recomendation)

			
func free_self():
	var whale_delete = preload("res://Scenes/whale_eat.tscn").instantiate()
	whale_delete.delete_this(self)
	
