extends Node
class_name Room_struct

enum CardinalDirection {NONE = 0, NORTH = 1 << 0, EAST = 1 << 1, SOUTH = 1 << 2, WEST = 1 << 3}
# Since it all is confusing just make it so: ClockWise, this way it will be at least manageable later
enum CombinedDirection {
	NONE = 0,
	NORTH = 1 << 0,
	EAST = 1 << 1,
	SOUTH = 1 << 2,
	WEST = 1 << 3,
	NORTHEASTSOUTHWEST = CardinalDirection.NORTH + CardinalDirection.EAST + CardinalDirection.SOUTH + CardinalDirection.WEST,
	NORTHEASTSOUTH = CardinalDirection.NORTH + CardinalDirection.EAST + CardinalDirection.SOUTH,
	NORTHEAST = CardinalDirection.NORTH + CardinalDirection.EAST,
	EASTSOUTHWEST = CardinalDirection.EAST + CardinalDirection.SOUTH + CardinalDirection.WEST,
	EASTSOUTH = CardinalDirection.EAST + CardinalDirection.SOUTH,
	SOUTHWESTNORTH = CardinalDirection.SOUTH + CardinalDirection.WEST + CardinalDirection.NORTH,
	SOUTHWEST = CardinalDirection.SOUTH + CardinalDirection.WEST,
	WESTNORTHEAST = CardinalDirection.WEST + CardinalDirection.NORTH + CardinalDirection.EAST,
	WESTNORTH = CardinalDirection.WEST + CardinalDirection.NORTH,
	NORTHSOUTH = CardinalDirection.NORTH + CardinalDirection.SOUTH,
	EASTWEST = CardinalDirection.EAST + CardinalDirection.WEST
	}

enum ROOM_TYPE{START, SIMPLE_COMBAT, OBSTACLE_COMBAT_1, OBSTACLE_COMBAT_2, OBSTACLE_COMBAT_3, TREASURE, SHOP, BOSS}

var starting_room: String = "res://Levels/starting_room.tscn"
var combat_room: String = "res://Levels/simple_combat_room.tscn"
var obstacle_c_1_room : String = "res://Levels/obstacle_combat_level_1.tscn"
var obstacle_c_2_room : String = "res://Levels/obstacle_combat_level_2.tscn"
var obstacle_c_3_room : String = "res://Levels/obstacle_combat_level_3.tscn"

#change this later
var treasure_room: String = "res://Levels/treasure_room.tscn"
var shop_room: String = "res://Levels/shop_room.tscn"
var boss_room: String = "res://Levels/boss_room.tscn"

@export var combined_directions : CombinedDirection = CombinedDirection.NONE

func assign_neighbor_combined_directions(dirs : CombinedDirection):
	combined_directions = dirs

func create_room(visited: bool, type: ROOM_TYPE) -> Dictionary:
	var scene = starting_room
	match type:
		ROOM_TYPE.START:
			scene = starting_room
		ROOM_TYPE.SIMPLE_COMBAT:
			scene = combat_room
		ROOM_TYPE.OBSTACLE_COMBAT_1:
			scene = obstacle_c_1_room
		ROOM_TYPE.OBSTACLE_COMBAT_2:
			scene = obstacle_c_2_room
		ROOM_TYPE.OBSTACLE_COMBAT_3:
			scene = obstacle_c_3_room
		ROOM_TYPE.TREASURE:
			scene = treasure_room
		ROOM_TYPE.SHOP:
			scene = shop_room
		ROOM_TYPE.BOSS:
			scene = boss_room
	return {
		"is_visited": visited,
		"type": type,
		"scene": scene,
		"combined_neighbour_dir" : CombinedDirection.NONE
	}
