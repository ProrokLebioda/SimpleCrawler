extends Node2D

var bullet_scene : PackedScene = preload("res://Characters/Player/bullet.tscn")
var chest_scene : PackedScene = preload("res://Objects/Interactables/chest_horizontal.tscn")

var area_collision_check : PackedScene = preload("res://Utils/area_collision_check.tscn")

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
	for i in chest_spawn_points.get_child_count():
		var child = chest_spawn_points.get_child(i)
		var chest = chest_scene.instantiate() as ItemContainer
		
		var chest_shape = chest.get_node("ChestOpenArea/CollisionShape2D").shape as CircleShape2D 
		var chest_radius = chest_shape.radius
		var pos = child.global_position
		if can_spawn_chest(chest_radius, pos):
			chest.position = pos
			objects_node.add_child(chest)
			break
		else:
			chest.queue_free()

func _on_enemy_died():
	enemies_count-= 1
	print("Enemy died! Remaining Enemy count: ", enemies_count)
	if (enemies_count <= 4):
		spawn_chest()

func can_spawn_chest(rad, position):
	# Create a temporary area2d and check
	var area_check = area_collision_check.instantiate() as Area2D
	area_check.position = position
	add_child(area_check)
	var shape  = area_check.get_node("CollisionShape2D").shape as CircleShape2D 
	
	shape.radius = rad
	var overlapping_bodies = area_check.get_overlapping_bodies()
	var overlapping_areas = area_check.get_overlapping_areas()
	
	#free area check as it's no longer needed
	area_check.queue_free()
	
	if overlapping_areas.size() <= 0 and overlapping_bodies.size() <= 0:
		return true
	else:
		return false
		
