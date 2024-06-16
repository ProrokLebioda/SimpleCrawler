extends Node2D

var white : Color = Color.WHITE
var transparent_white : Color = Color(1, 1, 1, 0.2)
var godot_blue : Color = Color("478cbf")
var grey : Color = Color("414042")

var explosion_radius : float = 10.0

func _draw():
	draw_arc(position,explosion_radius, 0,360, 40, transparent_white,1)
