extends Node
@onready var combat_room : PackedScene =  preload("res://Levels/simple_combat_room.tscn")
@onready var level = $Level

func _on_timer_timeout():
	level.get_child(0).queue_free()
	var level_new = combat_room.instantiate()
	level.add_child(level_new)
