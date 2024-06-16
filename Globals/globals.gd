extends Node

signal stat_change
signal weapon_changed(weapon : WeaponBase)
signal special_changed(special : SpecialAttackBase)
# Stats

var base_health : int =  8
var max_health : int = 20:
	get:
		return max_health
	set(val):
		if val < base_health:
			val = base_health
		max_health = val
		stat_change.emit()

var health = base_health:
	get:
		return health
	set(value):
		if value > health:
			health = min(value,max_health)
		else:	
			if player_vulnerable and value < health:
				player_vulnerable = false
				health = value
			else:
				health = value
		stat_change.emit()

var min_level : int = 1
var max_level : int = 30
var level : int = 0:
	get:
		return level
	set(val):
		level = val
		level_up()
		stat_change.emit()

var xp_per_level_base : int = 50
var xp : int = 0:
	get:
		return xp
	set(val):
		var xp_to_next_lvl = xp_per_level_base * level
		if val >= xp_to_next_lvl:
			# we don't want to lose extra exp, so 
			level += 1
			var overflow_xp = val - xp_to_next_lvl
			xp = overflow_xp
		else:
			xp = val
		stat_change.emit()

var base_movement_speed : float = 100.0
var min_movement_speed : float = 50.0
var max_movement_speed: float = 250.0
var movement_speed : float = base_movement_speed:
	get:
		return movement_speed
	set(val):
		if val < min_movement_speed:
			val = min_movement_speed
		if val > max_movement_speed:
			val = max_movement_speed
		movement_speed = val

var base_shoot_cooldown : float = 0.5
var max_shoot_cooldown : float = 1.5
var min_shoot_cooldown : float = 0.05
var shoot_cooldown : float = base_shoot_cooldown:
	get:
		return shoot_cooldown
	set(val):
		if val < min_shoot_cooldown:
			val = min_shoot_cooldown
		if val > max_shoot_cooldown:
			val = max_shoot_cooldown
		shoot_cooldown = val
		
var base_projectile_speed : float = 200
var min_projectile_speed : float = 100
var max_projectile_speed : float = 400
var projectile_speed : float = base_projectile_speed :
	get:
		return projectile_speed
	set(val):
		if val < min_projectile_speed:
			val = min_projectile_speed
		if val > max_projectile_speed:
			val = max_projectile_speed
		projectile_speed = val
		
var base_projectile_lifetime : float = 1.0
var min_projectile_lifetime : float = 0.3
var max_projectile_lifetime : float = 3.0
var projectile_lifetime : float = base_projectile_lifetime:
	get:
		return projectile_lifetime
	set(val):
		if val < min_projectile_lifetime:
			val = min_projectile_lifetime
		if val > max_projectile_lifetime:
			val = max_projectile_lifetime
		projectile_lifetime = val
# Info
var player_pos: Vector2
var player_velocity : Vector2
var player_collider_radius: float


var player_room : Vector3i = Vector3i(0,0,0) #start here
var player_at_level : int = 0 # this means game level, not player level

enum Entrance {NONE = 0, CENTER, NORTH, SOUTH, EAST, WEST}

var player_entered : Entrance = Entrance.NONE


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
		

var current_special : SpecialAttackBase:
	get:
		if !current_special:
			current_special = Specials.get_basic_special()
		return current_special
	set(new_special):
		current_special = new_special
		special_changed.emit(current_special)

var player_vulnerable: bool = true

#func player_invulnerable_timer():
#	await get_tree().create_timer(0.5).timeout
#	player_vulnerable = true

func level_up():
	movement_speed += 10.0
	max_health += 1
	# We need to heal by amount of max_health increase, could've been in max_health, but that caused me some headaches
	health += 1
	shoot_cooldown -= 0.1
	projectile_speed += 10.0
	projectile_lifetime += 0.05


func reset_player_stats():
	player_vulnerable = true
	movement_speed = base_movement_speed
	shoot_cooldown = base_shoot_cooldown
	projectile_speed = base_projectile_speed
	projectile_lifetime = base_projectile_lifetime
	xp = 0
	level = min_level
	max_health = base_health
	health = base_health
	player_at_level = 0
	coins = 0
	Levels.clear_rooms_visited_state()
	player_room = Vector3i(0,0,0)
	current_weapon = Weapons.get_basic_weapon()
	current_special = Specials.get_basic_special()
