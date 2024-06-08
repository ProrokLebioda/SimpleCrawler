extends CharacterBody2D
class_name StationaryShootingEnemy
enum ENEMY_STATE {IDLE, AGGRO, SHOOTING}

signal died()
signal _shoot(projectile: EnemyProjectile, pos: Vector2, dir : Vector2)

@export var projectile_scene : PackedScene

@export var idle_time : float = 2
@export var aggro_lose_time : float = 4
@export var base_damage : int = 2

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var aggro_lose_timer = $AggroLoseTimer
@onready var shot_timer = $ShotTimer
@onready var notice_area_collision = $NoticeArea/CollisionShape2D

@onready var hurtbox_collision_shape_2d = $CollisionShape2D
@onready var hitbox_collision_shape_2d = $DamageArea/CollisionShape2D


# Damage stuff
@export var health_max : int = 4
@onready var health : int = health_max
var vulnerable : bool = true
var hit_timer_wait_time : float = 0.2

var can_shoot : bool = true
@export var shoot_cooldown : float = 1.0

@export var xp_amount : int = 10
# Visual stuff

var look_direction : Vector2 = Vector2.ZERO
var current_state : ENEMY_STATE = ENEMY_STATE.IDLE
@export var death_particle : PackedScene

# Pushback 
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_force: float = 100.0
var knockback_val: Vector2 = Vector2.ZERO

# It's a workaround for a problem where player spawns in the middle and is moved 
var is_active : bool = false
# Additional Components
#@export var knockback_component: KnockbackComponent
func _ready():
	notice_area_collision.disabled = true

func _physics_process(delta):
	if is_active:
		process_state()
			
	if knockback_force > 0:
		knockback_val = knockback_direction * knockback_force
		
	if (current_state != ENEMY_STATE.IDLE):
		velocity = knockback_val
		move_and_slide()
	else:
		if (knockback_force > 0):
			velocity = knockback_val
			move_and_slide()
		else:
			velocity = Vector2.ZERO
			
	knockback_force = lerp(knockback_force, 0.0, 0.1)

func process_state():
	match current_state:
		ENEMY_STATE.IDLE:
			pass
		ENEMY_STATE.AGGRO:
			look_direction = (Globals.player_pos - position).normalized()
			flip_sprite_direction(look_direction)
		
			if can_shoot:
				# Shoot
				can_shoot = false
				current_state = ENEMY_STATE.SHOOTING
				pass
		ENEMY_STATE.SHOOTING:
			pick_new_state()
			pass
func select_new_direction():
	look_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	flip_sprite_direction(look_direction)
	

func flip_sprite_direction(look_dir : Vector2):
	if (look_dir.x < 0):
		sprite.flip_h = true
	elif(look_dir.x > 0):
		sprite.flip_h = false

func pick_new_state():
	pass
			

func _on_notice_area_body_entered(body):
	print("Body entered ",body.name )
		
	if (aggro_lose_timer.time_left > 0):
		aggro_lose_timer.stop()

	current_state = ENEMY_STATE.AGGRO

func _on_notice_area_body_exited(body):
	if (current_state != ENEMY_STATE.IDLE):
		if aggro_lose_timer.is_inside_tree():
			aggro_lose_timer.start(aggro_lose_time)
			print ("Aggro lose timer started")
		

func _on_aggro_lose_timer_timeout():
	pick_new_state()
	print ("Aggro lost")

func _on_damage_area_body_entered(body):
	
	if body is CharacterBody2D:
		print("Damage area entered: ", body.name)
		var enemy_pos = position
		# get direction to centre of other body, from enemy to body
		var body_pos = body.position
		var hit_direction = (body_pos-enemy_pos).normalized()
	
		if "hit" in body:
			body.hit(base_damage, hit_direction)

func hit(damage : int, dir: Vector2):
	if vulnerable:
		health -= damage
		vulnerable = false
		$HitTimer.start(hit_timer_wait_time)
		sprite.material.set_shader_parameter("progress", 1)
		
#		#pushback
#		if knockback_component:
		knockback_direction = dir 
		knockback_force = 100
		if (health <= 0):
			health = 0
			var particle = death_particle.instantiate()
			particle.position = global_position
			particle.rotation = global_rotation
			particle.emitting = true
			get_tree().current_scene.add_child(particle)
			# too coupled, maybe should be a signal... but I don't want to fiddle with this
			Globals.xp += xp_amount
			hitbox_collision_shape_2d.set_deferred("disabled", true)
			hurtbox_collision_shape_2d.set_deferred("disabled", true)
			died.emit(position)
			#queue_free()
			call_deferred("queue_free")

func _on_hit_timer_timeout():
	vulnerable = true
	sprite.material.set_shader_parameter("progress", 0)


func shoot_projectile():

	var projectile = projectile_scene.instantiate() as EnemyProjectile
	var dir = (Globals.player_pos - global_position).normalized()
	shot_timer.start(shoot_cooldown)
	_shoot.emit(projectile, global_position, dir)
	print("Shot!")
	pick_new_state()
	pass


func _on_shot_timer_timeout():
	can_shoot = true
#	if current_state == ENEMY_STATE.SHOOTING:
#		current_state = ENEMY_STATE.SHOOTING

func _on_initial_wait_timer_timeout():
	is_active = true
	$NoticeArea/CollisionShape2D.disabled = false
