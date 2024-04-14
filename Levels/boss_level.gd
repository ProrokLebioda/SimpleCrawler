extends LevelParent

@onready var boss_scene: PackedScene = preload("res://Enemies/boss_enemy.tscn")
@onready var enemies_spawn_points_node: Node2D = $BossSpawnPoints

var enemies_left_count : int = 0

func _ready():
	generate_level() # <=== TODO_Fix: A bandaid for when you enter you need to have info about room, but parent execution is called later which means we don't have correct info about visited state
	spawn_boss()
	enemies_left_count = enemies_node.get_child_count()
	super()
	# Get count of enemies
	print("Number of enemies: ", enemies_left_count)
	if enemies_left_count <= 0:
		level_cleared()
	
func spawn_boss():
	if !is_visited:
		var spawn_point = enemies_spawn_points_node.get_children().pick_random()
		var pos = spawn_point.global_position
		var boss = boss_scene.instantiate()
		boss.position = pos
		# Connect signals for enemies
		boss.connect("died", _on_enemy_died)
	
		enemies_node.add_child(boss)

func level_cleared():
	#custom logic
	if enemies_left_count <= 0:
		super()

	
func _on_enemy_died():
	enemies_left_count-= 1
	print("Enemy died! Remaining Enemy count: ", enemies_left_count)
	if (enemies_left_count <= 0):
		if get_tree() != null:
			level_cleared()
