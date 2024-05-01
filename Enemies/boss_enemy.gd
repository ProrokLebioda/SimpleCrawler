extends CharacterBody2D
enum ENEMY_STATE {IDLE, AGGRO, CHARGING}

signal died(death_pos)

@export var move_speed : float = 50
@export var charge_speed : float = 150
@export var idle_time : float = 2
@export var walk_time : float = 1
@export var aggro_lose_time : float = 4
@export var charge_cooldown : float = 3
# To avoid situation where boss would get stuck while not being able to reach destination
@export var max_time_in_charge_cooldown : float = 3 
@export var base_damage : int = 4

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var charge_timer = $ChargeTimer
@onready var idle_timer = $IdleTimer
@onready var max_time_in_charge_timer = $MaxTimeInChargeTimer

# Damage stuff
@export var health_max : int = 8
@onready var health : int = health_max
var vulnerable : bool = true
var hit_timer_wait_time : float = 0.2
#if player hit or destination reached
var destination_reached : bool = false
var can_charge: bool = true
# Visual stuff
var is_active = false

var move_direction : Vector2 = Vector2.ZERO
var current_state : ENEMY_STATE = ENEMY_STATE.IDLE

var destination : Vector2 = Vector2.INF

func _ready():
	#pick_new_state()
	$FightStartWaitTimer.start()

func _physics_process(delta):
	if is_active:
		process_state()

func process_state():
	var dest = Vector2.INF
	match current_state:
		ENEMY_STATE.IDLE:
			velocity = Vector2.ZERO
			dest = Vector2.INF
#		ENEMY_STATE.WALK:
#			flip_sprite_direction(move_direction)
#			velocity = move_direction * move_speed
#			move_and_slide()
		ENEMY_STATE.AGGRO:
			move_direction = (Globals.player_pos - position).normalized()
			flip_sprite_direction(move_direction)
			velocity = move_direction * move_speed
			move_and_slide()
			if can_charge:
				print("Charging")
				current_state = ENEMY_STATE.CHARGING
				max_time_in_charge_timer.start(max_time_in_charge_cooldown)
				destination = get_extended_point(position, Globals.player_pos)
				can_charge = false
				
				
		ENEMY_STATE.CHARGING:
			if destination != Vector2.INF:
				charge_timer.start(charge_cooldown)
				move_direction = (destination - position).normalized()
				flip_sprite_direction(move_direction)
				velocity = move_direction * charge_speed
				move_and_slide()
				
				if (position.distance_to(destination) < 2):
					print("Boss: Reached destination ")
					pick_new_state()
			else:
				pick_new_state()

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
			state_machine.travel("cow_walk_right")
			print("FromIdleToAggro")
			current_state = ENEMY_STATE.AGGRO
			select_new_direction()
		
#		ENEMY_STATE.WALK:
#			state_machine.travel("cow_idle_right")
#			print("ToIdle")
#			current_state = ENEMY_STATE.IDLE
#			idle_walk_timer.start(idle_time)
		
		ENEMY_STATE.AGGRO:
			print("FromAggroToIdle")
			state_machine.travel("cow_idle_right")
			#current_state = ENEMY_STATE.IDLE
			destination = Vector2.INF
			
		ENEMY_STATE.CHARGING:
			print("FromChargToIdle")
			stop_timers()
			# Cooldown starts after charge finishes
			charge_timer.start(charge_cooldown)
			state_machine.travel("cow_idle_right")
			current_state = ENEMY_STATE.IDLE
			idle_timer.start(idle_time)
			

func stop_timers():
	if (idle_timer.time_left > 0):
		idle_timer.stop()
	if max_time_in_charge_timer.time_left > 0:
		max_time_in_charge_timer.stop()


func hit(damage : int):
	if is_active:
		if vulnerable:
			health -= damage
			vulnerable = false
			$HitTimer.start(hit_timer_wait_time)
			sprite.material.set_shader_parameter("progress", 1)
			
		if (health <= 0):
			health = 0
			queue_free()

func _on_charge_timer_timeout():
	destination = Vector2.INF
	current_state = ENEMY_STATE.AGGRO
	can_charge = true
	print ("Charge refreshed")

func _on_damage_area_body_entered(body):
	if body is CharacterBody2D:
		destination = Vector2.INF
		if current_state == ENEMY_STATE.CHARGING:
			current_state = ENEMY_STATE.AGGRO

		print("Damage area entered: ", body.name)
		if "hit" in body:
			body.hit(base_damage)

func _on_idle_timer_timeout():
	if (current_state != ENEMY_STATE.AGGRO or current_state != ENEMY_STATE.CHARGING):
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


func _on_max_time_in_charge_timer_timeout():
	pick_new_state()
