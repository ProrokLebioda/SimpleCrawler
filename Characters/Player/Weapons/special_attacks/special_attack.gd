extends Node2D
class_name SpecialAttackBase

@onready var attack_scene : PackedScene = preload("res://Characters/Player/Weapons/special_attacks/bomb_attack.tscn")

var special_name : String = "SpecialBase"
@export var special_type : Specials.SpecialType = Specials.SpecialType.BOMB

func fire(pos: Vector2, dir: Vector2) -> Array[BombBase]:
	print("Special name: ", special_name)
	var attack = attack_scene.instantiate() as BombBase
	attack.direction_vector = dir
	attack.global_position = pos
	#attack.rotation_degrees = rad_to_deg(dir.angle()) + 90.0
	#attack.direction_vector = dir
	
	var attacks: Array[BombBase] = [attack]
	return attacks
