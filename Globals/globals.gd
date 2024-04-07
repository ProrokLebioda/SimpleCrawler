extends Node

signal stat_change

var healh_base: int =  8

var player_pos: Vector2
var player_collider_radius: float

var player_room : Vector2 = Vector2(0,0) #start here

enum Entrance {NONE = 0, NORTH, SOUTH, EAST, WEST}

var player_entered : Entrance = Entrance.NONE

var health = healh_base:
	get:
		return health
	set(value):
		if value > health:
			health = min(value,100)
		else:	
			if player_vulnerable:
				player_vulnerable = false
				player_invulnerable_timer()
				health = value
		stat_change.emit()

var player_vulnerable: bool = true

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout
	player_vulnerable = true


func reset_player_stats():
	health = healh_base
	player_room = Vector2(0,0)
