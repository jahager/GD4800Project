extends Node

# Get web content
func _on_search_button_pressed():
	var url: String = "https://musicrectest2.azurewebsites.net/api/recommendation?song=" + $TextEdit.text.uri_encode()
	$HTTPRequest.request(url)

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
