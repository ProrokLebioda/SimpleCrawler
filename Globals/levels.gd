extends Node

var number_of_rooms: int = 15

var levels : int = 3
var rooms : Dictionary 
var test_room_types = [Room_struct.ROOM_TYPE.SIMPLE_COMBAT,Room_struct.ROOM_TYPE.TREASURE, Room_struct.ROOM_TYPE.SHOP, Room_struct.ROOM_TYPE.BOSS]
var test_room_no_boss = [Room_struct.ROOM_TYPE.SIMPLE_COMBAT,Room_struct.ROOM_TYPE.TREASURE, Room_struct.ROOM_TYPE.SHOP]
@export var room_texture_scene : PackedScene = preload("res://UI/Map/minimap_room_texture.tscn")
var textmap_size : int = 16
var temp_rooms = []
# for now keep value that boss_room was spawned, to only have one
var is_boss_room_spawned : bool = false
var is_shop_room_spawned : bool = false

# Minimap stuff
var static_offset : Vector2i = Vector2i(100,100)

func _ready():
	generate_random_dungeon()
	#simple_test_dungeon()
	
	
func clear_rooms_visited_state():
	for room in rooms:
		rooms[room]["is_visited"] = false
	
	
func simple_test_dungeon():
	# Define a couple of Vector3 keys.
	# x & y are positions, z is depth/level
	var key1 = Vector3i(0,0,0)
	var key2 = Vector3i(0,1,0)
	var key3 = Vector3i(0,-1,0)
	var key4 = Vector3i(1,0,0)
	var key5 = Vector3i(-1,0,0)
	var key11 = Vector3i(0, 2, 0)
	
	var key6 = Vector3i(0,0,1)
	var key7 = Vector3i(0,1,1)
	var key8 = Vector3i(0,-1,1)
	var key9 = Vector3i(1,0,1)
	var key10 = Vector3i(-1,0,1)

	# Add Room structs to the dictionary using Vector2 keys.
	rooms[key1] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.START)
	rooms[key2] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.SIMPLE_COMBAT)
	rooms[key3] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.TREASURE)
	rooms[key4] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.SHOP)
	rooms[key5] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.BOSS)
	
	rooms[key6] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.START)
	rooms[key7] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.SIMPLE_COMBAT)
	rooms[key8] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.BOSS)
	rooms[key9] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.SHOP)
	rooms[key10] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.TREASURE)
	rooms[key11] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.TREASURE)
	levels = key10.z

func generate_random_dungeon():
	#generate some dungeon
	#Start at 0,0
	var values = [-1,0,1]
	var room_count = 0
	var curr_level = 0
	while curr_level < levels:
		var key = Vector3i(0,0,curr_level)
		rooms[key] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.START)
		temp_rooms = test_room_types
		while room_count < number_of_rooms:
			#pick random direction (no diagonal)
			# Direction is 
			var rand_value_x = randi_range(-1,1)
			var rand_value_y : int = randi_range(-1,1) if rand_value_x == 0 else 0
			var random_direction : Vector3i = Vector3i(rand_value_x, rand_value_y, 0)
			var new_room_position : Vector3i = key + random_direction
			#check if position is already occupied by another room
			if !rooms.has(new_room_position):
				#when we don't find room in rooms we can create new one,
				#for now as just a treasure for faster checking
				var value = randi_range(0, 9)
				var rand_type : Room_struct.ROOM_TYPE = temp_rooms.pick_random()
#				if is_boss_room_spawned and rand_type == Room_struct.ROOM_TYPE.BOSS:
#					# change boss room to other type
#					rand_type = test_room_no_boss.pick_random()
					
				rooms[new_room_position] = Room_struct.new().create_room(false, rand_type)
				if rand_type == Room_struct.ROOM_TYPE.BOSS:
					is_boss_room_spawned = true
					temp_rooms.erase(Room_struct.ROOM_TYPE.BOSS)
				
				if rand_type == Room_struct.ROOM_TYPE.SHOP:
					is_shop_room_spawned = true
					temp_rooms.erase(Room_struct.ROOM_TYPE.SHOP)

				room_count += 1
				key = new_room_position
		# make sure we have boss room at level
		if !is_boss_room_spawned:
			var keys_for_level = []
			var has_boss : bool = false
			for room in rooms:
				var room_key : Vector3i = room
				if room_key.z == curr_level:
					keys_for_level.append(room_key)
					
				# we don't want boss at start level
			keys_for_level.erase(Vector3i(0,0,curr_level))
			var random_room_key = keys_for_level.pick_random()
			# don't override Shop room, we want it on level
			while rooms[random_room_key]["type"]==Room_struct.ROOM_TYPE.SHOP:
				random_room_key = keys_for_level.pick_random()
			rooms[random_room_key] = Room_struct.new().create_room(false,  Room_struct.ROOM_TYPE.BOSS)
			is_boss_room_spawned = true
		##
		
		# reset room count, we want to generate next level, maybe in future change to array of room count per level
		room_count = 0
		# reset boss room spawned
		is_boss_room_spawned = false
		is_shop_room_spawned = false
		curr_level += 1
	
	levels = curr_level
	
#var dir_check = [Room_struct.CardinalDirection.NORTH, Room_struct.CardinalDirection.EAST, Room_struct.CardinalDirection.SOUTH, Room_struct.CardinalDirection.WEST]
#func _evaluate_neighbors():
#	for pos in Levels.rooms:
#		var room = Levels.rooms[pos]
#		# Check if there are rooms placed accordingly:
#		var combined_dir : Room_struct.CombinedDirection = Room_struct.CombinedDirection.NONE
#		print("Room: ", pos)
#		for dir in dir_check:
#			var nhb_room
#			var chck : Vector3i
#			var dir_name : String
#			match dir:
#				Room_struct.CardinalDirection.NORTH:
#					chck = pos + Vector3i(0,-1,0)
#					dir_name = "NORTH"
#				Room_struct.CardinalDirection.EAST:
#					chck = pos + Vector3i(1,0,0)
#					dir_name = "EAST"
#				Room_struct.CardinalDirection.SOUTH:
#					chck = pos + Vector3i(0,1,0)
#					dir_name = "SOUTH"
#				Room_struct.CardinalDirection.WEST:
#					chck = pos + Vector3i(-1,0,0)
#					dir_name = "WEST"
#
#			if Levels.rooms.has(chck):
#				nhb_room = Levels.rooms[chck]
#				#room.assign_neighbor(nhb_room, dir)
#				combined_dir += dir
#				print("Has room on ", dir_name)
#				room["combined_neighbor_dir"] = combined_dir
#		print("")
#
#func _setup_map():
#	for pos in Levels.rooms:
#		var room = Levels.rooms[pos]
#		var combined_dir = room["combined_neighbour_dir"] as Room_struct.CombinedDirection
#		var txtr = MinimapTextureAtlas.get_texture_for_direction(combined_dir)
#		var room_texture = room_texture_scene.instantiate() as TextureRect
#		room_texture.texture = txtr
#		textmap_size = room_texture.size.x
#		#room_texture.get_layout.get_transform().position.x = 100
#		room_texture.position = pos * textmap_size + static_offset
#		add_child(room_texture)
#
#
