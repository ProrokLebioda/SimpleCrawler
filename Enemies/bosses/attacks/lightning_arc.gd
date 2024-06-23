extends Node2D

var white : Color = Color.WHITE
@export var line_color : Color = Color(1, 1, 1, 0.8)
var godot_blue : Color = Color("478cbf")
var grey : Color = Color("414042")

@export var line_width : float = 1.0
var target_pos : Vector2
var has_target : bool = false

func _draw():
	if has_target:
		
		# Position has to be calculated, because drawing is happening based on current parent node position, meaning we need to substract current global position to get relative position
		var pos = target_pos - global_position
		draw_line(Vector2(0,0), pos, godot_blue, line_width, true)
