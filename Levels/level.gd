extends Node2D
class_name LevelParent

var bullet_scene : PackedScene = preload("res://Characters/Player/bullet.tscn")
var chest_scene : PackedScene = preload("res://Objects/Interactables/chest_horizontal.tscn")
var health_pickup_scene: PackedScene = preload("res://Objects/Item_Pickups/health_pickup.tscn")

var area_collision_check : PackedScene = preload("res://Utils/area_collision_check.tscn")

@onready var chest_spawn_points : Node2D = $ChestSpawnPoints
@onready var objects_node : Node2D = $Objects
@onready var projectiles_node : Node2D = $Projectiles
@onready var enemies_node: Node2D =  $Enemies

@onready var player_starts_node: Node2D = $PlayerStarts

# Scenes to transition
#@onready var north_scene : String = "res://Levels/combat_level.tscn"
#@onready var south_scene : String = "res://Levels/combat_level.tscn"


@onready var room: Dictionary
@onready var room_vector_position: Vector2

var enemies_count : int = 0

func _ready():
	generate_level()
	
	place_player()
	
	# Get count of enemies
	enemies_count = enemies_node.get_child_count()
	print("Number of enemies: ", enemies_count)
	if enemies_count <= 0:
		level_cleared()
	else:
		# Connect signals for enemies
		var node = get_tree().get_nodes_in_group("Enemies")
		for enemy in node[0].get_children():
			enemy.connect("died", _on_enemy_died)

func generate_level():
	#Test var for now
	room_vector_position = Vector2(0,0) 
	room = Levels.rooms[room_vector_position]
	print("Room at: ", room_vector_position, ", visited?: ", room["is_visited"], ", Type: ", room["type"])
	
func place_player():
	
	var player_position_markers = player_starts_node.get_children()
	var start_marker
	if (player_position_markers.size() == 1):
		start_marker = player_position_markers[0]
	else:
		# TODO_FIX: later change it or keep maps consistent as it uses indecies instead of know values, this means Markers2D for spawn need to have appropriate order now
		start_marker = player_position_markers[entered_to_exited(Globals.player_entered)-1]
	#var start_marker = player_position_markers[randi() % player_position_markers.size()]
	$Player.place_at_start(start_marker.global_position)

func _on_player_shoot_input_detected(pos, dir):
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation_degrees = rad_to_deg(dir.angle()) + 90.0
	bullet.direction_vector = dir
	projectiles_node.add_child(bullet)

func level_cleared():
	spawn_chest()
	unlock_doors()

func spawn_chest():
	var arr = get_property_list()
	var nm = name
	if chest_spawn_points != null and nm != "StartingLevel":
		for i in chest_spawn_points.get_child_count():
			var child = chest_spawn_points.get_child(i)
			var chest = chest_scene.instantiate() as ItemContainer
			
			var chest_shape = chest.get_node("ChestOpenArea/CollisionShape2D").shape as CircleShape2D 
			var chest_radius = chest_shape.radius
			var pos = child.global_position
			if can_spawn_chest(chest_radius, pos):
				chest.position = pos
				# Connect signal
				chest.connect("open", _on_container_opened)
				objects_node.add_child(chest)
				break
			else:
				chest.queue_free()

func _on_enemy_died():
	enemies_count-= 1
	print("Enemy died! Remaining Enemy count: ", enemies_count)
	if (enemies_count <= 0):
		spawn_chest()
		unlock_doors()

func can_spawn_chest(rad, position):
	var distance =  position.distance_to(Globals.player_pos) - (Globals.player_collider_radius + rad)
	if (distance >= 0):
		return true
	else:
		return false


func entered_to_exited(entered: Globals.Entrance):
	match entered:
		Globals.Entrance.NORTH:
			return Globals.Entrance.SOUTH
		Globals.Entrance.SOUTH:
			return Globals.Entrance.NORTH
		Globals.Entrance.EAST:
			return Globals.Entrance.WEST
		Globals.Entrance.WEST:
			return Globals.Entrance.EAST

func unlock_doors():
	if get_tree() != null:
		var doors = get_tree().get_nodes_in_group("Doors")
		for door in doors:
			door.open_door()
	
	

func _on_container_opened(pos, direction):
	var hp = health_pickup_scene.instantiate()
	objects_node.add_child(hp)


func _on_door_horizontal_north_body_entered(body):
	Globals.player_entered = Globals.Entrance.NORTH
	var position_north = Vector2(room_vector_position.x, room_vector_position.y + 1)
	var north_room = Levels.rooms[position_north]
	var scene = north_room["scene"] 
	get_tree().change_scene_to_file(scene)


func _on_door_horizontal_south_body_entered(body):
	Globals.player_entered = Globals.Entrance.SOUTH
	var position_south = Vector2(room_vector_position.x, room_vector_position.y - 1)
	var south_room = Levels.rooms[position_south]
	var scene = south_room["scene"] 
	get_tree().change_scene_to_file(scene)
	
func _on_door_horizontal_west_body_entered(body):
	Globals.player_entered = Globals.Entrance.WEST
	var position_west = Vector2(room_vector_position.x - 1, room_vector_position.y)
	var west_room = Levels.rooms[position_west]
	var scene = west_room["scene"] 
	get_tree().change_scene_to_file(scene)
	
func _on_door_horizontal_east_body_entered(body):
	Globals.player_entered = Globals.Entrance.EAST
	var position_east = Vector2(room_vector_position.x - 1, room_vector_position.y)
	var east_room = Levels.rooms[position_east]
	var scene = east_room["scene"] 
	get_tree().change_scene_to_file(scene)
