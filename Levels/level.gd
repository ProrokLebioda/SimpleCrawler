extends Node2D

var bullet_scene : PackedScene = preload("res://Characters/Player/bullet.tscn")
var chest_scene : PackedScene = preload("res://Objects/Interactables/chest_horizontal.tscn")

@onready var chest_spawn_points : Node2D = $ChestSpawnPoints
@onready var objects_node : Node2D = $Objects
@onready var projectiles_node : Node2D = $Projectiles
@onready var enemies_node: Node2D =  $Enemies

var enemies_count : int = 0

func _ready():
	# Get count of enemies
	enemies_count = enemies_node.get_child_count()
	print("Number of enemies: ", enemies_count)
	# Connect signals for enemies
	for enemy in get_tree().get_nodes_in_group('Enemies'):
		enemy.connect("died", _on_enemy_died)

func _on_player_shoot_input_detected(pos, dir):
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation_degrees = rad_to_deg(dir.angle()) + 90.0
	bullet.direction_vector = dir
	projectiles_node.add_child(bullet)


func spawn_chest():
	var pos = chest_spawn_points.get_child(randi()%chest_spawn_points.get_child_count()).global_position
	var chest = chest_scene.instantiate() as ItemContainer
	chest.position = pos
	objects_node.add_child(chest)

func _on_enemy_died():
	enemies_count-= 1
	print("Enemy died! Remaining Enemy count: ", enemies_count)
	if (enemies_count <= 0):
		spawn_chest()
