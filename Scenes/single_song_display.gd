extends Control

var json

func set_song(json):
	self.json = json
	var album_image = find_child("AlbumTextureRect")
	album_image.set_image(json["images"][0]["url"])
	
	var song_label = find_child("SongLabel")
	song_label.text = json["name"]
	var artist_label = find_child("ArtistLabel")
	artist_label.text = " ".join(json["artists"])


func _on_button_pressed():
	var dolphin_delete = preload("res://Scenes/move_off_screen.tscn").instantiate()
	dolphin_delete.delete_this(self)
	
	
