extends Control

var movee_start_position
var move_time = 3
@export var wobble_degrees: float = 5

func delete_this(movee: Control):
	var movee_parent = movee.get_parent()
	
	movee.get_tree().current_scene.add_child(self)
	self.movee_start_position = movee.global_position
	# TODO change start position to offscreen
	self.global_position = self.movee_start_position
	
	# Replace the movee with a shrinking control
	var shrinking_placeholder = shrinking_place_holder(movee)
	replace_child(movee, shrinking_placeholder)
	
	self.add_child(movee)
	movee.set_position(Vector2(0, 0))

func _ready():
	
	var screen_width = get_viewport().get_visible_rect().size.x
	var move_right = screen_width + $Sprite.get_rect().size.x
	
	# "Swim right"
	var tween = create_tween()
	tween.tween_property(self, "position:x", move_right, self.move_time)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.play()
	
	# delete self after animation
	tween.finished.connect(queue_free)
	
	# Wobble (swim) the sprite
	var rotate = create_tween()
	var wobble_time = 0.15
	var total_woble_time: int = 1 + int(self.move_time / (wobble_time * 2)) 
	for c in total_woble_time:
		rotate.tween_property($Sprite, "rotation_degrees", wobble_degrees, 0.15)
		rotate.tween_property($Sprite, "rotation_degrees", -wobble_degrees, 0.15)
	rotate.play()

func replace_child(old: Control, new: Control):
	var index: int = old.get_index()
	var old_parent = old.get_parent()
	old_parent.remove_child(old)
	old_parent.add_child(new)
	old_parent.move_child(new, index)
	

func shrinking_place_holder(old_control: Control, reduction_time = 1) -> Control:
	var new_control = Control.new()
	new_control.custom_minimum_size = old_control.size
	var reduce_size_tween = create_tween()
	reduce_size_tween.parallel().tween_property(new_control, "custom_minimum_size:x", 0, reduction_time)
	reduce_size_tween.parallel().tween_property(new_control, "custom_minimum_size:y", 0, reduction_time)
	reduce_size_tween.play()
	return new_control
