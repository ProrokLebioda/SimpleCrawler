extends Node

enum WeaponName{BASIC, TRIPPLE, ROTATING}

@onready var basic_weapon : WeaponBase
@onready var basic_weapon_scene : PackedScene = preload("res://Characters/Player/Weapons/weapon.tscn")

@onready var triple_weapon : WeaponBase
@onready var triple_weapon_scene : PackedScene = preload("res://Characters/Player/Weapons/tripple_shot.tscn")

@onready var rotating_weapon : WeaponBase
@onready var rotating_weapon_scene : PackedScene = preload("res://Characters/Player/Weapons/rotating_weapon.tscn")

@onready var weapons : Dictionary

func get_basic_weapon() -> WeaponBase:
	if !basic_weapon:
		basic_weapon = basic_weapon_scene.instantiate()
	return basic_weapon

func _ready():
	weapons[WeaponName.BASIC] = basic_weapon_scene
	weapons[WeaponName.TRIPPLE] = triple_weapon_scene
	weapons[WeaponName.ROTATING] = rotating_weapon_scene
		

func weapon_string_to_enum(name: String) ->WeaponName:
	match(name):
		"TripleShot":
			return WeaponName.TRIPPLE
		"RotatingWeapon":
			return WeaponName.ROTATING
	return WeaponName.BASIC

func weapon_enum_to_string(en : WeaponName)-> String:
	match(en):
		WeaponName.TRIPPLE:
			return "TripleShot"
		WeaponName.ROTATING:
			return "RotatingWeapon"
	return "WeaponBase"

func get_all_available_weapons() -> Dictionary:
	return weapons


