extends Node

enum Type { CHICKEN, COW, PORCUPINE, PERUN}

var bosses : Dictionary = {}

@onready var chicken_boss_scene : PackedScene = preload("res://Enemies/bosses/chicken_boss_enemy.tscn")
@onready var cow_boss_scene : PackedScene = preload("res://Enemies/bosses/cow_boss_enemy.tscn")
@onready var porcupine_boss_scene : PackedScene = preload("res://Enemies/bosses/porcupine_boss_enemy.tscn")
@onready var perun_boss_scene : PackedScene = preload("res://Enemies/bosses/perun_boss_enemy.tscn")

func _ready(): 
	bosses[Type.COW] = cow_boss_scene
	bosses[Type.CHICKEN] = chicken_boss_scene
	bosses[Type.PORCUPINE] = porcupine_boss_scene
	bosses[Type.PERUN] = perun_boss_scene

func get_boss_scene() -> PackedScene:
	var level = Globals.player_at_level
	
	if bosses.has(level):
		return bosses[level]
	else:
		return bosses[Type.CHICKEN]
