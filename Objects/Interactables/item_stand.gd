extends StaticBody2D
class_name ItemStand

@onready var current_direction: Vector2 = Vector2.DOWN.rotated(rotation)
@onready var audio_player = $AudioStreamPlayer

var is_used : bool = false
#signal open(position, direcion)
