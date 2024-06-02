extends CharacterBody2D
class_name BossBase
enum ENEMY_STATE {IDLE, WALK, AGGRO, CHARGING, LAY_EGG}

signal died(death_pos)

@export var move_speed : float = 50
@export var idle_time : float = 2
@export var walk_time : float = 1
@export var base_damage : int = 4

@onready var sprite = $Sprite2D
@onready var idle_timer = $Timers/IdleTimer
@onready var fight_start_wait_timer = $Timers/FightStartWaitTimer
@onready var hit_timer = $Timers/HitTimer


@export var xp_amount : int = 100

# Damage stuff
@export var health_max : int = 8
@onready var health : int = health_max
var vulnerable : bool = true
var hit_timer_wait_time : float = 0.2
#if player hit or destination reached
var destination_reached : bool = false
# Visual stuff
var is_active = false
@export var death_particle : PackedScene

var move_direction : Vector2 = Vector2.ZERO
var current_state : ENEMY_STATE = ENEMY_STATE.IDLE

var destination : Vector2 = Vector2.INF

func _ready():
	fight_start_wait_timer.start()

func _physics_process(delta):
	if is_active:
		process_state()

func process_state():
	var dest = Vector2.INF
	match current_state:
		ENEMY_STATE.IDLE:
			velocity = Vector2.ZERO
			dest = Vector2.INF
		ENEMY_STATE.WALK:
			flip_sprite_direction(move_direction)
			velocity = move_direction * move_speed
			move_and_slide()
		ENEMY_STATE.AGGRO:
			move_direction = (Globals.player_pos - position).normalized()
			flip_sprite_direction(move_direction)
			velocity = move_direction * move_speed
			move_and_slide()

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	flip_sprite_direction(move_direction)

func flip_sprite_direction(move_dir : Vector2):
	if (move_dir.x < 0):
		sprite.flip_h = true
	elif(move_dir.x > 0):
		sprite.flip_h = false
		
func get_extended_point(p, q):
	var vec = q - p
	var r = p + 2 * vec
	return r

func pick_new_state():
	match current_state:
		ENEMY_STATE.IDLE:
			#state_machine.travel("cow_walk_right")
			print("FromIdleToAggro")
			current_state = ENEMY_STATE.AGGRO
			select_new_direction()
		
		ENEMY_STATE.WALK:
			print("ToIdle")
			current_state = ENEMY_STATE.IDLE
		
		ENEMY_STATE.AGGRO:
			print("FromAggroToIdle")
			#state_machine.travel("cow_idle_right")
			#current_state = ENEMY_STATE.IDLE
			destination = Vector2.INF
			
		ENEMY_STATE.CHARGING:
			print("FromChargToIdle")
			stop_timers()
			# Cooldown starts after charge finishes
			#charge_timer.start(charge_cooldown)
			#state_machine.travel("cow_idle_right")
			current_state = ENEMY_STATE.IDLE
			idle_timer.start(idle_time)
			

func stop_timers():
	if (idle_timer.time_left > 0):
		idle_timer.stop()
#	if max_time_in_charge_timer.time_left > 0:
#		max_time_in_charge_timer.stop()


func hit(damage : int, dir: Vector2):
	if is_active:
		if vulnerable:
			health -= damage
			vulnerable = false
			hit_timer.start(hit_timer_wait_time)
			sprite.material.set_shader_parameter("progress", 1)
			
		if (health <= 0):
			health = 0
			var particle = death_particle.instantiate()
			particle.position = global_position
			particle.rotation = global_rotation
			particle.emitting = true
			get_tree().current_scene.add_child(particle)
			# too coupled
			Globals.xp += xp_amount
			queue_free()

func _on_damage_area_body_entered(body):
	if body is CharacterBody2D:
		destination = Vector2.INF
		if current_state == ENEMY_STATE.CHARGING:
			current_state = ENEMY_STATE.AGGRO

		print("Damage area entered: ", body.name)
		if "hit" in body:
			var boss_pos = position
			# get direction to centre of other body, from bullet to body
			var body_pos = body.position
			var hit_direction = (body_pos-boss_pos).normalized()
	
			body.hit(base_damage, hit_direction)

func _on_idle_timer_timeout():
	if (current_state != ENEMY_STATE.AGGRO or current_state != ENEMY_STATE.CHARGING or current_state != ENEMY_STATE.LAY_EGG):
		pick_new_state()

func _on_fight_start_wait_timer_timeout():
	is_active=true
	print("Boss starts")
	current_state = ENEMY_STATE.IDLE
	destination = Vector2.INF
	move_direction = Vector2.ZERO
	pick_new_state()
	
func _on_hit_timer_timeout():
	vulnerable = true
	sprite.material.set_shader_parameter("progress", 0)
	
func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		died.emit(position)

