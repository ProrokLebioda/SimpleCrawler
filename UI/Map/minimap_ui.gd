extends Control

@export var room_texture_scene : PackedScene = preload("res://UI/Map/minimap_room_texture.tscn")
@export var player_pos_marker_scene : PackedScene = preload("res://UI/Map/player_pos_marker_texture.tscn")
@export var boss_room_marker_scene : PackedScene = preload("res://UI/Map/boss_room_marker_texture.tscn")
@export var treasure_room_marker_scene : PackedScene = preload("res://UI/Map/treasure_room_marker_texture.tscn")
@export var shop_room_marker_scene : PackedScene = preload("res://UI/Map/shop_room_marker_texture.tscn")

var player_marker 
var boss_marker
var treasure_marker
var shop_marker
var textmap_size : int = 16

#@export var static_offset : Vector2i = Vector2i(200,50)
@export var static_offset : Vector2i = Vector2i(0,0)
var current_offset : Vector2i = static_offset
func _ready():
	player_marker = player_pos_marker_scene.instantiate()
	_evaluate_neighbors()
	_setup_map()
	
	add_child(player_marker)

var dir_check = [Room_struct.CardinalDirection.NORTH, Room_struct.CardinalDirection.EAST, Room_struct.CardinalDirection.SOUTH, Room_struct.CardinalDirection.WEST]
func _evaluate_neighbors():
	for pos in Levels.rooms:
		if pos.z != Globals.player_room.z:
			continue
		var room = Levels.rooms[pos]
		# change to func
		if room["is_visited"] == false and (Globals.player_room != pos and (pos != Globals.player_room + Vector3i(0,1,0) and pos != Globals.player_room + Vector3i(0,-1,0) and pos != Globals.player_room + Vector3i(1,0,0) and pos != Globals.player_room + Vector3i(-1,0,0))):
			continue
		# Check if there are rooms placed accordingly:
		var combined_dir : Room_struct.CombinedDirection = Room_struct.CombinedDirection.NONE
		print("Room: ", pos)
		for dir in dir_check:
			var nhb_room
			var chck : Vector3i
			var dir_name : String
			match dir:
				Room_struct.CardinalDirection.NORTH:
					chck = pos + Vector3i(0,1,0)
					dir_name = "NORTH"
				Room_struct.CardinalDirection.EAST:
					chck = pos + Vector3i(1,0,0)
					dir_name = "EAST"
				Room_struct.CardinalDirection.SOUTH:
					chck = pos + Vector3i(0,-1,0)
					dir_name = "SOUTH"
				Room_struct.CardinalDirection.WEST:
					chck = pos + Vector3i(-1,0,0)
					dir_name = "WEST"

			if Levels.rooms.has(chck):
				nhb_room = Levels.rooms[chck]
				combined_dir += dir
				print("Has room on ", dir_name)
				room["combined_neighbor_dir"] = combined_dir
		print("")

func _setup_map():
	for pos in Levels.rooms:
		if pos.z != Globals.player_room.z:
			continue
		var room = Levels.rooms[pos]
		# change to func
		var visited = room["is_visited"] 
		if visited == false and (Globals.player_room != pos and (pos != Globals.player_room + Vector3i(0,1,0) and pos != Globals.player_room + Vector3i(0,-1,0) and pos != Globals.player_room + Vector3i(1,0,0) and pos != Globals.player_room + Vector3i(-1,0,0))):
			continue
		
		
		var combined_dir = room["combined_neighbor_dir"] as Room_struct.CombinedDirection
		var txtr = MinimapTextureAtlas.get_texture_for_direction(combined_dir)
		var room_texture = room_texture_scene.instantiate() as TextureRect
		room_texture.texture = txtr
		textmap_size = room_texture.size.x
		current_offset = static_offset - Vector2i(Globals.player_room.x,-Globals.player_room.y)*textmap_size 
		room_texture.global_position = Vector2i(pos.x, -pos.y) * textmap_size + current_offset
		
		if visited == false and pos != Globals.player_room:
			room_texture.modulate.a = .5
		add_child(room_texture)
		if room["type"] == Room_struct.ROOM_TYPE.BOSS:
			_prepare_marker(boss_marker, boss_room_marker_scene, pos, current_offset, visited)
		
		if room["type"] == Room_struct.ROOM_TYPE.TREASURE:
			_prepare_marker(treasure_marker, treasure_room_marker_scene, pos, current_offset, visited)
		
		if room["type"] == Room_struct.ROOM_TYPE.SHOP:
			_prepare_marker(shop_marker, shop_room_marker_scene, pos, current_offset, visited)
		
		if Globals.player_room == pos:
			player_marker.global_position = Vector2i(pos.x, -pos.y) * textmap_size + current_offset
	

func _prepare_marker(marker : TextureRect, marker_scene : PackedScene, pos: Vector3i, current_offset: Vector2i, visited : bool):
	marker = marker_scene.instantiate() as TextureRect
	marker.size = Vector2(textmap_size,textmap_size)
	marker.global_position = Vector2i(pos.x, -pos.y) * textmap_size + current_offset
	if visited == false and pos != Globals.player_room:
		marker.modulate.a = .5
	add_child(marker)
