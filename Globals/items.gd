extends Node

enum PickupType {
	SPEED,
	HEALTH_INCREASE,
	HEAL,
	COOLDOWN,
	PROJECTILE_LIFETIME,
	PROJECTILE_SPEED,
	ROTATING_PICKUP,
	TRIPLE_PICKUP,
	}

var items : Dictionary

var allowed_items : Array[PickupType] = [
	PickupType.SPEED,
	PickupType.HEALTH_INCREASE,
	PickupType.HEAL,
	PickupType.COOLDOWN,
	PickupType.PROJECTILE_LIFETIME,
	PickupType.PROJECTILE_SPEED,
	PickupType.ROTATING_PICKUP,
	PickupType.TRIPLE_PICKUP]

var speed_pickup : PackedScene = preload("res://Objects/Item_Pickups/speed_pickup.tscn")
var projectile_speed_pickup : PackedScene = preload("res://Objects/Item_Pickups/projectile_speed_pickup.tscn")
var projectile_lifetime_pickup : PackedScene = preload("res://Objects/Item_Pickups/projectile_lifetime_pickup.tscn")
var health_pickup : PackedScene = preload("res://Objects/Item_Pickups/health_pickup.tscn")
var health_increase_pickup : PackedScene = preload("res://Objects/Item_Pickups/health_increase_pickup.tscn")
var cooldown_pickup : PackedScene = preload("res://Objects/Item_Pickups/cooldown_pickup.tscn")

# weapons
var rotating_pickup : PackedScene = preload("res://Objects/Item_Pickups/Weapons/rotating_pickup.tscn")
var triple_pickup : PackedScene = preload("res://Objects/Item_Pickups/Weapons/triple_pickup.tscn")

func _ready():
	_fill_items()
	pass
	
func _fill_items():
	# [Type, PackedScene, COST] 
	items[PickupType.SPEED] = {"scene": speed_pickup, "cost": 3}
	items[PickupType.HEALTH_INCREASE] = {"scene": health_increase_pickup, "cost": 10}
	items[PickupType.HEAL] = {"scene": health_pickup, "cost": 2}
	items[PickupType.COOLDOWN] = {"scene": cooldown_pickup, "cost": 4}
	items[PickupType.PROJECTILE_LIFETIME] = {"scene": projectile_lifetime_pickup, "cost": 3}
	items[PickupType.PROJECTILE_SPEED] = {"scene": projectile_speed_pickup, "cost": 4}
	items[PickupType.ROTATING_PICKUP] = {"scene": rotating_pickup, "cost": 12}
	items[PickupType.TRIPLE_PICKUP] = {"scene": triple_pickup, "cost": 20}
	
func get_random_item() -> Dictionary:
	var random_type = allowed_items.pick_random()
	
	return items[random_type]
