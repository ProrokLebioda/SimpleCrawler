extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

#parameters/Idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var shoot_cooldown : float = 0.5
@onready var shoot_timer = $ShootTimer

var can_shoot : bool = true

# Signals
signal shoot_input_detected(pos, dir)

func _ready():
	update_animation_parameters(starting_direction)

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction.normalized()*move_speed
	
	move_and_slide()
	pick_new_state()
	
	var shoot_direction = Vector2(
		Input.get_action_strength("s_right")-Input.get_action_strength("s_left"),
		Input.get_action_strength("s_down")-Input.get_action_strength("s_up")
	)
	
	if (shoot_direction != Vector2.ZERO) and can_shoot:
		can_shoot = false
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


func _on_shoot_timer_timeout():
	can_shoot = true
