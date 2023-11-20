extends Control

var movee_start_position = Vector2(0, 0)
var move_in_time = 0.5
var move_out_time = 2
@export var wobble_degrees: float = 1

var target_position
var movee

func delete_this(movee: Control):
	self.movee = movee
	var movee_parent = movee.get_parent()
	
	movee.get_tree().current_scene.add_child(self)
	
	#First target position
	self.target_position = movee.global_position
	# TODO change start position to offscreen
	self.global_position = self.movee_start_position
	
	
	
	var tween = create_tween()
	
	var screen_width = get_viewport().get_visible_rect().size.x
	var move_right = screen_width + $Sprite.get_rect().size.x
	
	# "Swim right"
	tween.tween_property(self, "position:x", self.target_position.x, self.move_in_time)
	tween.parallel().tween_property(self, "position:y", self.target_position.y, self.move_in_time)

	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(second_animation)
	tween.play()
	
	
	
#	# Wobble (swim) the sprite
#	var rotate = create_tween()
#	var wobble_time = 0.15
#	var total_woble_time: int = 1 + int(self.move_time / (wobble_time * 2)) 
#	for c in total_woble_time:
#		rotate.tween_property($Sprite, "rotation_degrees", wobble_degrees, 0.15)
#		rotate.tween_property($Sprite, "rotation_degrees", -wobble_degrees, 0.15)
#	rotate.play()

func attach_movee():
	# Replace the movee with a shrinking control
	var shrinking_placeholder = shrinking_place_holder(self.movee)
	replace_child(self.movee, shrinking_placeholder)
	
	self.add_child(self.movee)
	self.movee.set_position(Vector2(0, 0))

func second_animation():
	attach_movee()
	var tween = create_tween()
	
	var screen_width = get_viewport().get_visible_rect().size.x
	var move_right = screen_width + $Sprite.get_rect().size.x
	
	# "Swim right"
	tween.tween_property(self, "position:x", move_right, self.move_out_time)
	tween.parallel().tween_property(self, "position:y", -20, self.move_out_time)

	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	# delete self after animation
	tween.finished.connect(queue_free)
	tween.play()

func _ready():
	pass

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
