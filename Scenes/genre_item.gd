extends HBoxContainer

var genre: String

func _on_button_pressed():
	self.queue_free()

func get_text():
	return $Label.text

func set_text(new_text):
	genre = new_text
	$Label.text = new_text
