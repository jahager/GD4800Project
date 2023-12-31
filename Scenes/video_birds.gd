extends Control

@onready var bird_wobble_amount = 10
@onready var bird_wobble_tween = create_tween()
@onready var video_screen = $CenterContainer
var left_dove_exists = true
var right_dove_exists = true
@onready var bird_height = $LeftDove.get_rect().size.y
@onready var screen_move_tween: Tween


func _ready():
	
	# Fix dolphin spin issue
	$CenterContainer/SpinDolphin.pivot_offset = Vector2(75, 75)
	
	# Start bird fly wobble
	self.bird_wobble_tween.finished.connect(_bird_wobble)
	_bird_wobble()
	
	#lower to mid
	drop_mid_from_top()
	
	# On window size change, move to center
	get_viewport().size_changed.connect(move_to_center)
	

func get_play_video(video_name: String):
	$CenterContainer/AspectContainer/VideoStreamYTPlayer.find_download(video_name)

func play():
	$CenterContainer/AspectContainer/VideoStreamYTPlayer.play_video()

func drop_mid_from_top():
	$".".global_position.y = 0
	var screen_width = get_viewport().get_visible_rect().size.x
	var self_width = $CenterContainer/ColorRect.custom_minimum_size.x
	$".".position.x = (screen_width / 2) - (self_width / 2)
	
	var screen_height = get_viewport().get_visible_rect().size.y
	var self_height = $".".get_rect().size.y
	var target_y_mid = screen_height / 2  + self_height / 2
	var drop_mid_tween = create_tween()
	drop_mid_tween.set_ease(Tween.EASE_OUT)
	drop_mid_tween.set_trans(Tween.TRANS_ELASTIC)
	drop_mid_tween.tween_property($".", "global_position:y", target_y_mid, 8)
	drop_mid_tween.play()
	
func move_to_center():
	if self.screen_move_tween:
		self.screen_move_tween.kill()
	self.screen_move_tween = create_tween()
	var screen_width = get_viewport().get_visible_rect().size.x
	var self_width = $CenterContainer/ColorRect.custom_minimum_size.x
	var target_x_mid = (screen_width / 2) - (self_width / 2)
	
	var screen_height = get_viewport().get_visible_rect().size.y
	var self_height = $".".get_rect().size.y
	var target_y_mid = screen_height / 2  + self_height / 2
	
	self.screen_move_tween.set_ease(Tween.EASE_OUT)
	self.screen_move_tween.set_trans(Tween.TRANS_ELASTIC)
	self.screen_move_tween.parallel().tween_property($".", "global_position:y", target_y_mid, 8)
	self.screen_move_tween.parallel().tween_property($".", "global_position:x", target_x_mid, 8)
	self.screen_move_tween.play()

func _bird_wobble():
	# Stop animation when objects are gone.
	if not self.left_dove_exists and not self.right_dove_exists:
		self.bird_wobble_tween.finished.disconnect(_bird_wobble)
		return
	
	self.bird_wobble_tween.stop()
	self.bird_wobble_tween.set_ease(Tween.EASE_IN_OUT)
	self.bird_wobble_tween.set_trans(Tween.TRANS_CUBIC)
	if self.left_dove_exists:
		self.bird_wobble_tween.parallel().tween_property($LeftDove, "rotation_degrees", self.bird_wobble_amount, 0.45)
	if self.right_dove_exists:
		self.bird_wobble_tween.parallel().tween_property($RightDove, "rotation_degrees", -self.bird_wobble_amount, 0.45)
	self.bird_wobble_tween.play()
	self.bird_wobble_amount = -self.bird_wobble_amount

func drop_video(is_drop_left: bool = true):
	# If dropping left use positive angle, else use negative
	var negate = 1 if is_drop_left else -1
	# When dropping right, set pivot point to right side
	if not is_drop_left:
		var vid_width = video_screen.get_rect().size.x
		video_screen.pivot_offset = Vector2(vid_width, 0)
	
	var rotate_tween = create_tween()
	rotate_tween.set_ease(Tween.EASE_OUT)
	rotate_tween.set_trans(Tween.TRANS_ELASTIC)
	rotate_tween.tween_property(self.video_screen, "rotation_degrees", 60 * negate, 2)
	
	rotate_tween.play()


func _on_right_dove_pressed():
	feather_maker($RightDove)
	$RightDove.queue_free()
	self.right_dove_exists = false
	
	drop_off_screen()
	
	if self.left_dove_exists:
		drop_video()

func feather_maker(target_object: Control):
	var random = RandomNumberGenerator.new()
	random.randomize()
	for num in range(0, 10):
		var feather = preload("res://Scenes/feather.tscn").instantiate()
		var x_pos = (target_object.global_position.x + random.randi()%150) - 75 + target_object.get_rect().size.x / 2
		random.randomize()
		var y_pos = (target_object.global_position.y + random.randi()%150) - 75 + target_object.get_rect().size.y / 2
		feather.global_position = Vector2(x_pos, y_pos)
		get_viewport().add_child(feather)

func _on_left_dove_pressed():
	feather_maker($LeftDove)
	$LeftDove.queue_free()
	self.left_dove_exists = false
	
	drop_off_screen()
	
	if self.right_dove_exists:
		drop_video(false)

func drop_off_screen():
	# Drops entire self off screen and self deletes
	var screen_height = get_viewport().get_visible_rect().size.y
	var move_down = screen_height + $".".get_rect().size.y + self.bird_height
	var drop_tween = create_tween()
	drop_tween.finished.connect(queue_free)
	drop_tween.set_ease(Tween.EASE_IN_OUT)
	drop_tween.set_trans(Tween.TRANS_CUBIC)
	drop_tween.tween_property(self, "position:y", move_down, 2)
	drop_tween.play()

	
