extends RoomParent

@onready var boss_scene: PackedScene = preload("res://Enemies/bosses/cow_boss_enemy.tscn")
@onready var ladder_scene: PackedScene = preload("res://Objects/Statics/ladder_down.tscn")
@onready var enemies_spawn_points_node: Node2D = $BossSpawnPoints
@onready var enemy_died_sound = $Sounds/EnemyDiedSound

var enemies_left_count : int = 0

func _ready():
	generate_level() # <=== TODO_Fix: A bandaid for when you enter you need to have info about room, but parent execution is called later which means we don't have correct info about visited state
	spawn_boss()
	enemies_left_count = enemies_node.get_child_count()
	spawn_ladder(Vector2(0,0))
	super()
	if is_visited == false:
		AudioPlayer.play_boss_music(-10.0)
	# Get count of enemies
	print("Number of enemies: ", enemies_left_count)
	if enemies_left_count <= 0:
		room_cleared()

	
func spawn_boss():
	if !is_visited:
		var spawn_point = enemies_spawn_points_node.get_children().pick_random()
		var pos = spawn_point.global_position
		var boss = boss_scene.instantiate()
		boss.position = pos
		# Connect signals for enemies
		boss.connect("died", _on_enemy_died)
	
		enemies_node.add_child(boss)

func room_cleared():
	#custom logic
	AudioPlayer.play_music_level(-10.0)
	if enemies_left_count <= 0:
		super()

	
func _on_enemy_died(death_position):
	if get_tree() != null:
		enemies_left_count-= 1
		enemy_died_sound.play()
		print("Boss died! Remaining Boss count: ", enemies_left_count)
		if (enemies_left_count <= 0):
			room_cleared()
			
			#if player cleared last boss, end game
			# TODO_CHANGE: Change back to checking last available level 
			if Globals.player_at_level == (Levels.levels-1):
				await enemy_died_sound.finished
				get_tree().change_scene_to_file("res://UI/game_finished.tscn")
			else:
				spawn_ladder(death_position)
				await enemy_died_sound.finished


func spawn_ladder(spawn_position):
	if get_tree() != null:
		if enemies_left_count <= 0:
			var ladder = ladder_scene.instantiate()
			ladder.connect("player_entered_ladder", _on_player_entered_ladder)
			ladder.global_position = spawn_position
			objects_node.add_child(ladder)
		
func _on_player_entered_ladder():
	print("Change levels")
	Globals.player_entered = Globals.Entrance.CENTER
	var new_player_room = Vector3i(0,0,Globals.player_at_level+1)
	update_player_room(new_player_room)
	Levels.rooms[room_vector_position]["is_visited"] = true
	ui.queue_free()
	get_tree().change_scene_to_file(Levels.rooms[new_player_room]["scene"])
