extends RoomParent

class_name CombatLevel

#@onready var enemy_scene: PackedScene = preload("res://Enemies/fodder_enemies/chick_enemy.tscn")
@onready var enemy_scene: PackedScene = preload("res://Enemies/fodder_enemies/plant_cannon_enemy.tscn")
@onready var enemies_spawn_points_node: Node2D = $EnemiesSpawnPoints

@onready var coin_scene: PackedScene = preload("res://Objects/Item_Pickups/coin_pickup.tscn")

var enemies_left_count : int = 0
#@export var enemies_number: int = 3
@export var min_enemies_number: int = 3
@export var max_enemies_number: int = 13

@onready var enemy_died_sound = $Sounds/EnemyDiedSound


func _ready():
	enemy_scene = BasicEnemies.get_basic_enemy_scene()
	generate_level() # <=== TODO_Fix: A bandaid for when you enter you need to have info about room, but parent execution is called later which means we don't have correct info about visited state
	spawn_enemies()
	#enemies_left_count = enemies_node.get_child_count()
	super()
	# Get count of enemies
	print("Number of enemies: ", enemies_left_count)
	if enemies_left_count <= 0:
		room_cleared()
	
func spawn_enemies():
	if !is_visited:
		var spawn_points = enemies_spawn_points_node.get_children()
		var random_number_enemies_count = randi() % max_enemies_number + 2
		for i in random_number_enemies_count -1:
			if i >= spawn_points.size():
				break
			var position = spawn_points[i].global_position
			var new_enemy = enemy_scene.instantiate()
			new_enemy.position = position
			# Connect signals for enemies
			new_enemy.connect("died", _on_enemy_died)
			if new_enemy is StationaryShootingEnemy:
				new_enemy.connect("_shoot", _spawn_enemy_projectile)
		
			enemies_node.add_child(new_enemy)
			enemies_left_count+=1

func room_cleared():
	#custom logic
	if enemies_left_count <= 0:
		super()
	
func _on_enemy_died(death_position):
	enemies_left_count-= 1
	if get_tree() != null:
		spawn_coin(death_position)
		enemy_died_sound.play()
	print("Enemy died! Remaining Enemy count: ", enemies_left_count)
	if (enemies_left_count <= 0):
		if get_tree() != null:
			room_cleared()

func spawn_coin(spawn_position):
	if get_tree() != null:
		var coin = coin_scene.instantiate()
		coin.global_position = spawn_position
		objects_node.call_deferred("add_child",coin )
		#objects_node.add_child(coin)

func _spawn_enemy_projectile(projectile : EnemyProjectile, pos : Vector2, dir : Vector2):
	projectile.position = pos
	projectile.direction_vector = dir
	# Some projectiles might not require rotating, but let's add it for more advanced sprites
	var angle = Vector2.UP.angle_to(dir)
	projectile.rotate(angle)
	projectiles_node.add_child(projectile)
