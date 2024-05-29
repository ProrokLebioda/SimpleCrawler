extends Node

signal stat_change
signal weapon_changed(weapon : WeaponBase)
# Stats
var healh_base: int =  8

var player_pos: Vector2
var player_collider_radius: float

var level : int = 0:
	get:
		return level
	set(val):
		level = val

var base_movement_speed : float = 100.0
var max_movement_speed: float = 250.0
var movement_speed : float = base_movement_speed:
	get:
		return movement_speed
	set(val):
		if val > max_movement_speed:
			val = max_movement_speed
		movement_speed = val

var base_shoot_cooldown : float = 0.5
var min_shoot_cooldown : float = 0.05
var shoot_cooldown : float = base_shoot_cooldown:
	get:
		return shoot_cooldown
	set(val):
		if val < min_shoot_cooldown:
			val = min_shoot_cooldown
		shoot_cooldown = val
# Info
var player_room : Vector3i = Vector3i(0,0,0) #start here
var player_at_level : int = 0 # this means game level, not player level

enum Entrance {NONE = 0, CENTER, NORTH, SOUTH, EAST, WEST}

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
				health = value
		stat_change.emit()

var coins = 0:
	get:
		return coins
	set(value):
		coins = value
		stat_change.emit()
		
var current_weapon : WeaponBase:
	get:
		if !current_weapon:
			current_weapon = Weapons.get_basic_weapon()
		return current_weapon
	set(new_weapon):
		current_weapon = new_weapon
		weapon_changed.emit(current_weapon)
		

var player_vulnerable: bool = true

#func player_invulnerable_timer():
#	await get_tree().create_timer(0.5).timeout
#	player_vulnerable = true


func reset_player_stats():
	movement_speed = base_movement_speed
	shoot_cooldown = base_shoot_cooldown
	level = 0
	health = healh_base
	
	player_at_level = 0
	coins = 0
	Levels.clear_rooms_visited_state()
	player_room = Vector3i(0,0,0)
	current_weapon = Weapons.get_basic_weapon()
