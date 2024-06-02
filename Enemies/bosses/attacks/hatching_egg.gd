extends StaticBody2D
class_name HatchingEgg

@onready var animation_player = $Animations/AnimationPlayer
@onready var hatch_start_timer = $Timers/HatchStartTimer

@export var health : int = 1

@export var time_to_start_hatching : float = 1.0

# What to spawn?
@export var spawn_animal_scene : PackedScene
signal spawned_animal(animal : SimpleEnemy, pos : Vector2)

func _ready():
	hatch_start_timer.start(time_to_start_hatching)

func _on_hatch_started():
	animation_player.play("hatching")

func _on_hatch():
	var enemy = spawn_animal_scene.instantiate() as SimpleEnemy
	spawned_animal.emit(enemy, position)
	
	queue_free()

func hit(damage : int, dir: Vector2):
	health -= damage
	if (health <= 0):
		health = 0
		queue_free()
