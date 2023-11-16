extends Node2D

var start_point: Vector2 = Vector2(0.0, 0.0)
var end_point: Vector2 = Vector2(0.0, 0.0)
var solid_color: Color = Color.RED
var width: int = 10

func shoot(start, end):
	start_point = start
	end_point = end
	self.show()
	$Timer.start()

func _draw():
	draw_line(start_point, end_point, solid_color, width)
	draw_circle(start_point, width/2, solid_color)
	draw_circle(end_point, width/2, solid_color)

func _process(delta):
	queue_redraw()


func _on_timer_timeout():
	self.hide()
