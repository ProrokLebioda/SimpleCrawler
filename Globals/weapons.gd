extends Node

@onready var basic_weapon : WeaponBase

@onready var weapons : Dictionary

func get_basic_weapon() -> WeaponBase:
	return basic_weapon

func _ready():
	weapons[0] = basic_weapon
	pass

func get_all_available_weapons() -> Dictionary:
	return weapons
