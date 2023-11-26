extends Node

var background_tween: Tween
var neg = -1
@onready var loop_pixel_amount = $BackgroundTextureRect.position.x + (256 * neg)
@onready var original_position = $BackgroundTextureRect.position

func _ready():
	background_tween = create_tween()
	background_tween.set_trans(Tween.TRANS_LINEAR)
	background_tween.set_loops()
	background_tween.loop_finished.connect(_reset_background)
	background_tween.tween_property($BackgroundTextureRect, "position:x", self.loop_pixel_amount, 20.0)
	background_tween.play()

func flip_direction():
	self.neg *= -1
	background_tween.stop()
	background_tween.play()

func _reset_background(loop_index):
	$BackgroundTextureRect.position = self.original_position
