extends Node

enum SpecialType { BOMB}


@onready var bomb_special : SpecialAttackBase
@onready var bomb_special_scene : PackedScene = preload("res://Characters/Player/Weapons/special_attacks/special_attack.tscn")


@onready var specials : Dictionary

func get_basic_special() -> SpecialAttackBase:
	if !bomb_special:
		bomb_special = bomb_special_scene.instantiate()
	return bomb_special

func _ready():
	specials[SpecialType.BOMB] = bomb_special_scene
		

func special_string_to_enum(name: String) ->SpecialType:
	match(name):
		"Bomb":
			return SpecialType.BOMB
	return SpecialType.BOMB

func special_enum_to_string(en : SpecialType)-> String:
	match(en):
		SpecialType.BOMB:
			return "Bomb"
	return "Bomb"

func get_all_available_specials() -> Dictionary:
	return specials


