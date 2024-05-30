extends Node2D
class_name RoomParent

#var bullet_scene : PackedScene = preload("res://Characters/Player/bullet.tscn")
var chest_scene : PackedScene = preload("res://Objects/Interactables/chest_horizontal.tscn")
var health_pickup_scene: PackedScene = preload("res://Objects/Item_Pickups/health_pickup.tscn")

var area_collision_check : PackedScene = preload("res://Utils/area_collision_check.tscn")

@onready var chest_spawn_points : Node2D = $ChestSpawnPoints
@onready var objects_node : Node2D = $Objects
@onready var projectiles_node : Node2D = $Projectiles
@onready var enemies_node: Node2D =  $Enemies

@onready var player_starts_node: Node2D = $PlayerStarts

# Scenes to transition
@onready var pause_menu = $Utils/PauseMenu/PauseMenuLayout
@onready var settings_menu = $Utils/PauseMenu/settings_menu

@onready var room: Dictionary
@onready var room_vector_position: Vector3i
var is_visited: bool = false


# Player weapon stuff
@export var current_weapon: WeaponBase
@onready var player_weapon_node = $PlayerWeapon

func _input(event):
	if event.is_action_pressed("escape"):
		_on_pause()
		
func _ready():
	generate_level()
	place_player()
	assign_player_weapon()
	room_cleared()
	AudioPlayer.play_music_level(-12.0)
	Globals.connect("weapon_changed", _on_weapon_changed)
	
func _on_weapon_changed(new_weapon):
	var all_weapons = player_weapon_node.get_children()
	for wp in all_weapons:
		wp.queue_free()
	assign_player_weapon()
	

func generate_level():
	room_vector_position = Globals.player_room
	room = Levels.rooms[room_vector_position]
	is_visited = room["is_visited"]
	print("Room at: ", room_vector_position, ", visited?: ", room["is_visited"], ", Type: ", room["type"])
	
func place_player():
	
	var player_position_markers = player_starts_node.get_children()
	var start_marker
	if (room_vector_position.x == 0 and room_vector_position.y == 0 and !is_visited):
		start_marker = pick_spawn_point(Globals.Entrance.CENTER)
	else:
		start_marker = pick_spawn_point(entered_to_exited(Globals.player_entered))
	$Player.place_at_start(start_marker.global_position, room_vector_position.z)

func assign_player_weapon():
	var wp = Globals.current_weapon as WeaponBase
	var weapon_scene = Weapons.weapons[wp.weapon_enum]
	if weapon_scene:
		var weapon_for_player = weapon_scene.instantiate()
		player_weapon_node.add_child(weapon_for_player)
		current_weapon = weapon_for_player

func pick_spawn_point(entrance: Globals.Entrance):
	for marker in player_starts_node.get_children():
		if marker.name == spawn_enum_to_string(entrance):
			return marker

func _on_pause():
	get_tree().paused = !get_tree().paused
	$Utils/PauseMenu.visible = !$Utils/PauseMenu.visible
	if $Utils/PauseMenu.visible:
		$Utils/PauseMenu/PauseMenuLayout/VBoxContainer/ContinueButton.grab_focus()

func spawn_enum_to_string(entrance: Globals.Entrance):
	match entrance:
		Globals.Entrance.NORTH:
			return 'North'
		Globals.Entrance.SOUTH:
			return 'South'
		Globals.Entrance.WEST:
			return 'West'
		Globals.Entrance.EAST:
			return 'East'
		Globals.Entrance.CENTER:
			return 'Center'

func _on_player_shoot_input_detected(pos, dir):
	if current_weapon != null:
		var bullets = current_weapon.fire(pos, dir)
		
		for bullet in bullets:
			projectiles_node.add_child(bullet)
	else:
		print_verbose("No weapon")

func room_cleared():
	if !is_visited:
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
		Globals.Entrance.CENTER:
			return Globals.Entrance.CENTER

func unlock_doors():
	#check if door will actually lead somewhere?
	var doors = get_tree().get_nodes_in_group("Doors")
	for door in doors:
		print(door.name)
		if is_door_leading_somewhere(door.name):
			door.open_door()
	
func is_door_leading_somewhere(door_name):
	match door_name:
		'DoorNorth':
			var position_north = Vector3i(room_vector_position.x, room_vector_position.y + 1, room_vector_position.z)
			if Levels.rooms.has(position_north):
				return true
			else:
				return false
		'DoorSouth':
			var position_south = Vector3i(room_vector_position.x, room_vector_position.y - 1, room_vector_position.z)
			if Levels.rooms.has(position_south):
				return true
			else:
				return false
		'DoorWest':
			var position_west = Vector3i(room_vector_position.x - 1, room_vector_position.y, room_vector_position.z)
			if Levels.rooms.has(position_west):
				return true
			else:
				return false
		'DoorEast':
			var position_east = Vector3i(room_vector_position.x + 1, room_vector_position.y, room_vector_position.z)
			if Levels.rooms.has(position_east):
				return true
			else:
				return false

func _on_container_opened(pos, direction):
	var random_item = Items.get_random_item() as Dictionary
	var item_scene = random_item["scene"]
	#var item = item_pickup_scene.instantiate()
	var item = item_scene.instantiate()
	item.position = pos
	objects_node.add_child(item)

func _on_door_horizontal_north_body_entered(body):
	Globals.player_entered = Globals.Entrance.NORTH
	var position_north = Vector3i(room_vector_position.x, room_vector_position.y + 1, room_vector_position.z)
	if Levels.rooms.has(position_north):
		var north_room = Levels.rooms[position_north]
		var scene = north_room["scene"] 
		update_player_room(position_north)
		on_room_leave()
		get_tree().change_scene_to_file(scene)


func _on_door_horizontal_south_body_entered(body):
	Globals.player_entered = Globals.Entrance.SOUTH
	var position_south = Vector3i(room_vector_position.x, room_vector_position.y - 1, room_vector_position.z)
	if Levels.rooms.has(position_south):		
		var south_room = Levels.rooms[position_south]
		var scene = south_room["scene"] 
		update_player_room(position_south)
		on_room_leave()
		get_tree().change_scene_to_file(scene)
	
func _on_door_horizontal_west_body_entered(body):
	Globals.player_entered = Globals.Entrance.WEST
	var position_west = Vector3i(room_vector_position.x - 1, room_vector_position.y, room_vector_position.z)
	if Levels.rooms.has(position_west):
		var west_room = Levels.rooms[position_west]
		var scene = west_room["scene"] 
		update_player_room(position_west)
		on_room_leave()
		get_tree().change_scene_to_file(scene)
	
func _on_door_horizontal_east_body_entered(body):
	Globals.player_entered = Globals.Entrance.EAST
	var position_east = Vector3i(room_vector_position.x + 1, room_vector_position.y, room_vector_position.z)
	if Levels.rooms.has(position_east):
		var east_room = Levels.rooms[position_east]
		var scene = east_room["scene"] 
		update_player_room(position_east)
		on_room_leave()
		get_tree().change_scene_to_file(scene)

func update_player_room(new_room_pos: Vector3):
	Globals.player_room  = new_room_pos
	
func on_room_leave():
	room = Levels.rooms[room_vector_position]
	room["is_visited"] = true

func _on_main_menu_button_pressed():
	AudioPlayer._stop_music()
	get_tree().change_scene_to_file("res://UI/Menu/main_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	pass # Replace with function body.
