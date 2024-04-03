extends Node
class_name Room_struct

	
func create_room(visited: bool, type: int) -> Dictionary:
	return {
		"is_visited": visited,
		"type": type
	}
