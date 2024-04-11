extends Node


var number_of_rooms: int = 15

var rooms = {}
var test_room_types = [Room_struct.ROOM_TYPE.SIMPLE_COMBAT,Room_struct.ROOM_TYPE.TREASURE, Room_struct.ROOM_TYPE.BOSS]
var test_room_no_boss = [Room_struct.ROOM_TYPE.SIMPLE_COMBAT,Room_struct.ROOM_TYPE.TREASURE]
# for now keep value that boss_room was spawned, to only have one
var is_boss_room_spawned: bool = false
func _ready():
	#generate_random_dungeon()
	simple_test_dungeon()
	
func clear_rooms_visited_state():
	for room in rooms:
		rooms[room]["is_visited"] = false
	
	
func simple_test_dungeon():
	# Define a couple of Vector2 keys.
	var key1 = Vector2(0,0)
	var key2 = Vector2(0,1)
	var key3 = Vector2(0,-1)
	var key4 = Vector2(1,0)
	var key5 = Vector2(-1,0)
	
	# Add Room structs to the dictionary using Vector2 keys.
	rooms[key1] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.START)
	rooms[key2] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.SIMPLE_COMBAT)
	rooms[key3] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.TREASURE)
	rooms[key4] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.SHOP)
	rooms[key5] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.BOSS)

func generate_random_dungeon():
	#generate some dungeon
	#Start at 0,0
	var values = [-1,0,1]
	var room_count = 0
	var key = Vector2(0,0)
	rooms[key] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.START)
	while room_count < number_of_rooms:
		#pick random direction (no diagonal)
		# Direction is 
		var rand_value_x = randi_range(-1,1)
		var rand_value_y : int = randi_range(-1,1) if rand_value_x == 0 else 0
		var random_direction = Vector2(rand_value_x, rand_value_y)
		var new_room_position = key + random_direction
		#check if position is already occupied by another room
		if !rooms.has(new_room_position):
			#when we don't find room in rooms we can create new one,
			#for now as just a treasure for faster checking
			var value = randi_range(0, 9)
			var rand_type : Room_struct.ROOM_TYPE = test_room_types.pick_random()
			if is_boss_room_spawned and rand_type == Room_struct.ROOM_TYPE.BOSS:
				# change boss room to other type
				rand_type = test_room_no_boss.pick_random()
				
			rooms[new_room_position] = Room_struct.new().create_room(false, rand_type)
			if rand_type == Room_struct.ROOM_TYPE.BOSS:
				is_boss_room_spawned = true
			room_count += 1
			key = new_room_position
		
	
