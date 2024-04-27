extends CharacterBody2D
enum ENEMY_STATE {IDLE, WALK, AGGRO}

signal died()

@export var move_speed : float = 30
@export var idle_time : float = 2
@export var walk_time : float = 2
@export var aggro_lose_time : float = 4
@export var base_damage : int = 2

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var idle_walk_timer = $IdleWalkTimer
@onready var aggro_lose_timer = $AggroLoseTimer

# Damage stuff
@export var health_max : int = 4
@onready var health : int = health_max
var vulnerable : bool = true
var hit_timer_wait_time : float = 0.2
# Visual stuff

var move_direction : Vector2 = Vector2.ZERO
var current_state : ENEMY_STATE = ENEMY_STATE.IDLE

func _ready():
	pick_new_state()
	
func _physics_process(delta):
	if (current_state == ENEMY_STATE.AGGRO):
		move_direction = (Globals.player_pos - position).normalized()
		flip_sprite_direction(move_direction)
		
	if (current_state != ENEMY_STATE.IDLE):
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

func pick_new_state():
	match current_state:
		ENEMY_STATE.IDLE:
			state_machine.travel("chicken_walk_right")
			print("ToWalk")
			current_state = ENEMY_STATE.WALK
			select_new_direction()
			idle_walk_timer.start(walk_time)
		
		ENEMY_STATE.WALK:
			state_machine.travel("chicken_idle_right")
			print("ToIdle")
			current_state = ENEMY_STATE.IDLE
			idle_walk_timer.start(idle_time)
		
		ENEMY_STATE.AGGRO:				
			state_machine.travel("chicken_idle_right")
			current_state = ENEMY_STATE.IDLE
			idle_walk_timer.start(idle_time)
			

func _on_notice_area_body_entered(body):
	print("Body entered ",body.name )
	state_machine.travel("chicken_walk_right")
	if (idle_walk_timer.time_left > 0):
		idle_walk_timer.stop()
		
	if (aggro_lose_timer.time_left > 0):
		aggro_lose_timer.stop()

	current_state = ENEMY_STATE.AGGRO

func _on_notice_area_body_exited(body):
	if (current_state == ENEMY_STATE.AGGRO):
		if aggro_lose_timer.is_inside_tree():
			aggro_lose_timer.start(aggro_lose_time)
			print ("Aggro lose timer started")
		
func _on_idle_walk_timer_timeout():
	if (current_state != ENEMY_STATE.AGGRO):
		pick_new_state()


func _on_aggro_lose_timer_timeout():
	pick_new_state()
	print ("Aggro lost")


func _on_damage_area_body_entered(body):
	
	if body is CharacterBody2D:
		print("Damage area entered: ", body.name)
		if "hit" in body:
			body.hit(base_damage)

func hit(damage : int):
	if vulnerable:
		health -= damage
		vulnerable = false
		$HitTimer.start(hit_timer_wait_time)
		sprite.material.set_shader_parameter("progress", 1)
		
		
	if (health <= 0):
		health = 0
		queue_free()

func _on_hit_timer_timeout():
	vulnerable = true
	sprite.material.set_shader_parameter("progress", 0)

func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		died.emit()
