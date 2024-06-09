extends Node

enum Type {CHICK, CANNON_PLANT}

@onready var chick_scene : PackedScene = preload("res://Enemies/fodder_enemies/chick_enemy.tscn")
@onready var cannon_plant_scene : PackedScene = preload("res://Enemies/fodder_enemies/plant_cannon_enemy.tscn")
var basic_enemies_scenes : Dictionary = {}

func _ready(): 
	basic_enemies_scenes[Type.CHICK] = chick_scene
	basic_enemies_scenes[Type.CANNON_PLANT] = cannon_plant_scene


func get_basic_enemy_scene() -> PackedScene:
	var level = Globals.player_at_level
	
	if basic_enemies_scenes.has(level):
		return basic_enemies_scenes[level]
	else:
		return basic_enemies_scenes[Type.CHICK]

func generate_random_enemy_scene():
	pass
