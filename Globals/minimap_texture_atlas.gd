extends Node

@export var map_room_four_doors = preload("res://Art/minimap/map_rooms/map_room_four_doors.png")

@export var map_room_three_doors_a = preload("res://Art/minimap/map_rooms/map_room_three_doors_a.png")
@export var map_room_three_doors_b = preload("res://Art/minimap/map_rooms/map_room_three_doors_b.png")
@export var map_room_three_doors_c = preload("res://Art/minimap/map_rooms/map_room_three_doors_c.png")
@export var map_room_three_doors_d = preload("res://Art/minimap/map_rooms/map_room_three_doors_d.png")

@export var map_room_two_doors_a = preload("res://Art/minimap/map_rooms/map_room_two_doors_a.png")
@export var map_room_two_doors_b = preload("res://Art/minimap/map_rooms/map_room_two_doors_b.png")
@export var map_room_two_doors_c = preload("res://Art/minimap/map_rooms/map_room_two_doors_c.png")
@export var map_room_two_doors_d = preload("res://Art/minimap/map_rooms/map_room_two_doors_d.png")
@export var map_room_two_doors_e = preload("res://Art/minimap/map_rooms/map_room_two_doors_e.png")
@export var map_room_two_doors_f = preload("res://Art/minimap/map_rooms/map_room_two_doors_f.png")

@export var map_room_one_door_a = preload("res://Art/minimap/map_rooms/map_room_one_door_a.png")
@export var map_room_one_door_b = preload("res://Art/minimap/map_rooms/map_room_one_door_b.png")
@export var map_room_one_door_c = preload("res://Art/minimap/map_rooms/map_room_one_door_c.png")
@export var map_room_one_door_d = preload("res://Art/minimap/map_rooms/map_room_one_door_d.png")

func get_texture_for_direction(dirs : Room_struct.CombinedDirection) -> CompressedTexture2D:
	match dirs as Room_struct.CombinedDirection:
		Room_struct.CombinedDirection.NORTH:
			return map_room_one_door_c
		Room_struct.CombinedDirection.EAST:
			return map_room_one_door_d
		Room_struct.CombinedDirection.SOUTH:
			return map_room_one_door_a
		Room_struct.CombinedDirection.WEST:
			return map_room_one_door_b
		Room_struct.CombinedDirection.NORTHEASTSOUTHWEST:
			return map_room_four_doors
		Room_struct.CombinedDirection.NORTHEASTSOUTH:
			return map_room_three_doors_d
		Room_struct.CombinedDirection.NORTHEAST:
			return map_room_two_doors_d
		Room_struct.CombinedDirection.EASTSOUTHWEST:
			return map_room_three_doors_a
		Room_struct.CombinedDirection.EASTSOUTH:
			return map_room_two_doors_e
		Room_struct.CombinedDirection.SOUTHWESTNORTH:
			return map_room_three_doors_b
		Room_struct.CombinedDirection.SOUTHWEST:
			return map_room_two_doors_f
		Room_struct.CombinedDirection.WESTNORTHEAST:
			return map_room_three_doors_c
		Room_struct.CombinedDirection.WESTNORTH:
			return map_room_two_doors_c
		Room_struct.CombinedDirection.NORTHSOUTH:
			return map_room_two_doors_a
		Room_struct.CombinedDirection.EASTWEST:
			return map_room_two_doors_b
		_:
			return CompressedTexture2D.new()
