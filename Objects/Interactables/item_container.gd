extends StaticBody2D
class_name ItemContainer

@onready var current_direction: Vector2 = Vector2.DOWN.rotated(rotation)
@onready var audio_player = $AudioStreamPlayer

var is_opened : bool = false
signal open(position, direcion)
