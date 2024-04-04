extends Node
class_name Room_struct
enum ROOM_TYPE{START, SIMPLE_COMBAT, TREASUE, SHOP, BOSS}

var starting_room: String = "res://Levels/starting_level.tscn"
var combat_room: String = "res://Levels/combat_level.tscn"

#change this later
var treasure_room: String = "res://Levels/treasure_level.tscn"
var shop_room: String = "res://Levels/combat_level.tscn"
var boss_room: String = "res://Levels/combat_level.tscn"

func create_room(visited: bool, type: ROOM_TYPE) -> Dictionary:
	var scene = starting_room
	match type:
		ROOM_TYPE.START:
			scene = starting_room
		ROOM_TYPE.SIMPLE_COMBAT:
			scene = combat_room
		ROOM_TYPE.TREASUE:
			scene = treasure_room
		ROOM_TYPE.SHOP:
			scene = shop_room
		ROOM_TYPE.BOSS:
			scene = boss_room
	return {
		"is_visited": visited,
		"type": type,
		"scene": scene
	}
