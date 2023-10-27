extends VBoxContainer

# Create GUI list of songs/album images
func add_json(json):
	var vbox = VBoxContainer.new()
	self.add_child(vbox)
	
	for recomendation in json:
			var hbox = HBoxContainer.new()
			vbox.add_child(hbox)
			
			var album_image = load("res://Scenes/texture_rect_url.tscn").instantiate()
			var image_containter = AspectRatioContainer.new()
			image_containter.add_child(album_image)
			image_containter.set_size(Vector2(100,100))
			image_containter.custom_minimum_size = Vector2(100,100)
			hbox.add_child(image_containter)
			album_image.set_image(recomendation["images"][0]["url"])
		
			print(recomendation["name"])
			print(recomendation["artists"])
			var song_label = Label.new()
			song_label.text = recomendation["name"] + " -" 
			for artist in recomendation["artists"]:
				song_label.text = song_label.text + " " + artist
			hbox.add_child(song_label)
