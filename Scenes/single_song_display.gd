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
	
	$VideoStreamYTPlayer.connect("download_complete", show_play_button)
	$VideoStreamYTPlayer.find_download(get_song_artist_string())

func show_play_button():
	$PlayButton.show()
	$PlayButton.modulate.a = 0
	var show_tween = create_tween()
	show_tween.tween_property($PlayButton, "modulate:a", 1, 1)
	show_tween.play()

func _on_button_pressed():
	var dolphin_delete = preload("res://Scenes/move_off_screen.tscn").instantiate()
	dolphin_delete.delete_this(self)

func get_song_artist_string():
	return json["name"] + " ".join(json["artists"])

func _on_play_button_pressed():
	var music_video = preload("res://Scenes/video_birds.tscn").instantiate()
	
	self.get_viewport().add_child(music_video)
	music_video.get_play_video(get_song_artist_string())
	music_video.play()
