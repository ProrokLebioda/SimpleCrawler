extends Node2D

var white : Color = Color.WHITE
@export var circle_color : Color = Color(1, 1, 1, 0.2)
var godot_blue : Color = Color("478cbf")
var grey : Color = Color("414042")

@export var explosion_radius : float = 10.0

func _draw():
	draw_arc(position, explosion_radius, 0,360, 40, circle_color,1)
