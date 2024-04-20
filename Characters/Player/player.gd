extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

#parameters/Idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var shoot_cooldown : float = 0.5
@onready var shoot_timer = $ShootTimer

# sounds
@onready var audio_player = $AudioStreamPlayer

var can_shoot : bool = true

# Signals
signal shoot_input_detected(pos, dir)

func _ready():
	update_animation_parameters(starting_direction)
	var collider_shape = get_node("CollisionShape2D").shape as CapsuleShape2D 
	Globals.player_collider_radius = collider_shape.radius

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction.normalized()*move_speed
	
	move_and_slide()
	
	Globals.player_pos = global_position
	pick_new_state()
	
	var shoot_direction = Vector2(
		Input.get_action_strength("s_right")-Input.get_action_strength("s_left"),
		Input.get_action_strength("s_down")-Input.get_action_strength("s_up")
	)
	
	if (shoot_direction != Vector2.ZERO) and can_shoot:
		can_shoot = false
		audio_player.play()
		shoot_timer.start(shoot_cooldown)
		shoot_input_detected.emit(position, shoot_direction.normalized())


func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

func place_at_start(pos : Vector2, level_depth : int):
	global_position = pos
	Globals.player_pos = global_position
	Globals.player_at_level = level_depth

# "Interfaces"...
func hit(damage):
	Globals.health -= damage
	print("Player received: ", damage, " damage. Current player health: ", Globals.health)
	if Globals.health <= 0:
		print("PLAYER DIED!")
		get_tree().change_scene_to_file("res://UI/game_over.tscn")

func _on_shoot_timer_timeout():
	can_shoot = true
	
