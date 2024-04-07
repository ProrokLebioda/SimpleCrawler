extends Node



var rooms = {}

func _ready():
	generate_random_dungeon()
	
func clear_rooms_visited_state():
	for room in rooms:
		rooms[room]["is_visited"] = false
	
func generate_random_dungeon():
	# Define a couple of Vector2 keys.
	var key1 = Vector2(0,0)
	var key2 = Vector2(0,1)
	var key3 = Vector2(0,-1)
	var key4 = Vector2(1,0)
	var key5 = Vector2(-1,0)
	
	# Add Room structs to the dictionary using Vector2 keys.
	rooms[key1] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.START)
	rooms[key2] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.SIMPLE_COMBAT)
	rooms[key3] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.TREASUE)
	rooms[key4] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.SHOP)
	rooms[key5] = Room_struct.new().create_room(false, Room_struct.ROOM_TYPE.BOSS)
