extends CharacterBody2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

# Special spawns
@onready var special_spawns = $SpecialSpawns
@onready var spawn_left = $SpecialSpawns/Left
@onready var spawn_right = $SpecialSpawns/Right
@onready var spawn_down = $SpecialSpawns/Down
@onready var spawn_up = $SpecialSpawns/Up


#parameters/Idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

# Timers' stuf
@onready var shoot_cooldown : float = 0.5
@onready var special_cooldown : float = 2.5

@onready var shoot_timer = $Timers/ShootTimer
@onready var invulnerable_timer = $Timers/InvulnerableTimer
@onready var special_timer = $Timers/SpecialTimer

@export var invulnerable_time : float = 0.5
# sounds
@onready var audio_player = $AudioStreamPlayer
@export var hit_sfx : AudioStream
var can_shoot : bool = true
var can_shoot_special : bool = true

#visuals
@onready var sprite_2d = $Sprite2D

var acceleration : float = 10
# Pushback
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_force: float = 100.0
var knockback_val: Vector2 = Vector2.ZERO
# Signals
signal shoot_input_detected(pos, dir)
signal shoot_input_special_detected(pos, dir)

func _ready():
	update_animation_parameters(starting_direction)
	var collider_shape = get_node("CollisionShape2D").shape as CapsuleShape2D 
	Globals.player_collider_radius = collider_shape.radius

func _physics_process(delta):
#	var input_direction = Vector2(
#		Input.get_action_strength("right")-Input.get_action_strength("left"),
#		Input.get_action_strength("down")-Input.get_action_strength("up")
#	)
	var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down")
	acceleration = Globals.movement_speed / 5
	
	update_animation_parameters(input_direction)
	if knockback_force > 0:
		knockback_val = knockback_direction * knockback_force
	var quickness = lerp(velocity, Vector2(Globals.movement_speed,Globals.movement_speed), 0.8)
	#velocity = input_direction.normalized() * Globals.movement_speed + knockback_val
	velocity.x = move_toward(velocity.x, Globals.movement_speed * input_direction.x + knockback_val.x, acceleration)
	velocity.y = move_toward(velocity.y, Globals.movement_speed * input_direction.y + knockback_val.y, acceleration)
	velocity += knockback_val
	move_and_slide()
	knockback_force = lerp(knockback_force, 0.0, 0.7)
	Globals.player_pos = global_position
	Globals.player_velocity = velocity
	pick_new_state()
	
#	var shoot_direction = Vector2(
#		Input.get_action_strength("s_right")-Input.get_action_strength("s_left"),
#		Input.get_action_strength("s_down")-Input.get_action_strength("s_up")
#	)
	var shoot_direction : Vector2 = Input.get_vector("s_left", "s_right", "s_up", "s_down")
	
	if (shoot_direction != Vector2.ZERO) and can_shoot:
		#Fix sound issues
		can_shoot = false
		audio_player.play()
		shoot_timer.start(Globals.shoot_cooldown)
		shoot_input_detected.emit(position, shoot_direction.normalized())

	# This one is tricky... some attacks should go where movement direction is, bomb is dropped in this way
	var is_special_attack : bool = Input.is_action_pressed("special_attack")
	if is_special_attack and can_shoot_special:
		can_shoot_special = false
		var spawn_pos = _get_special_spawn_position()
		special_timer.start(special_cooldown)
		shoot_input_special_detected.emit(spawn_pos, velocity.normalized())
		

func _get_special_spawn_position() -> Vector2:
	# Don't overcomplicate. Take player movement vector, normalize, multiply by 2. If 0 then take facing?
	var move_dir = velocity.normalized()
	var spawn_pos : Vector2 = global_position
	if move_dir != Vector2.ZERO:
		spawn_pos += move_dir * 12
	else:
		# offset somehow. Taking value from animation_tree is a hacky way to do this
		var value = animation_tree.get("parameters/Idle/blend_position")
		spawn_pos += value * 12
	return spawn_pos

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
func hit(damage: int, dir: Vector2):
	Globals.health -= damage
	invulnerable_timer.start(invulnerable_time)
	knockback_direction = dir 
	knockback_force = 100
	AudioPlayer.play_FX(hit_sfx,-12.0)
	sprite_2d.material.set_shader_parameter("progress", 1)
	print("Player received: ", damage, " damage. Current player health: ", Globals.health)
	if Globals.health <= 0:
		print("PLAYER DIED!")
		get_tree().change_scene_to_file("res://UI/game_over.tscn")

func _on_shoot_timer_timeout():
	can_shoot = true
	
func _on_invulnerable_timer_timeout():
	sprite_2d.material.set_shader_parameter("progress", 0)
	Globals.player_vulnerable = true


func _on_special_timer_timeout():
	can_shoot_special = true
