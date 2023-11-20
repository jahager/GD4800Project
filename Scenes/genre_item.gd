extends HBoxContainer

var genre: String

func _on_button_pressed():
	self.free_self()

func get_text():
	return $Label.text

func set_text(new_text):
	genre = new_text
	$Label.text = new_text

func free_self():
	var eagle_delete = preload("res://Scenes/eagle_remove.tscn").instantiate()
	eagle_delete.delete_this(self)
