extends RigidBody2D
class_name BombBase
@onready var animation_player = $AnimationPlayer
@onready var explosion_timer = $ExplosionTimer
@onready var explosion_duration_timer = $ExplosionDurationTimer
@onready var explosion_zone_collision = $ExplosionZone/CollisionShape2D
@onready var explosion_particles = $ExplosionParticles

@export var time_to_explode : float = 1.0
@onready var bomb_sprite = $Sprite2D
@onready var bomb_collision_shape = $CollisionShape2D

# How long explosion lingers applying damage in range
@export var explosion_duration : float = 0.2
@export var damage : int = 10
@export var special_type : Specials.SpecialType = Specials.SpecialType.BOMB
@export var move_speed : float = 250.0

@export var push_force : float = 10000.0

var is_explosion_ongoing : bool = false
# Only needed sometimes
var direction_vector : Vector2 = Vector2.ZERO

@export var move_dampening : float = 0.1
@onready var explosion_circle = $ExplosionCircle

# Perhaps should be growing outwards, but let's just do instant full range
var explosion_range : float = 0.0
func _ready():
	explosion_range = explosion_zone_collision.shape.radius
	animation_player.play("bomb_fuse_burn")
	apply_central_force(direction_vector*push_force)
func _physics_process(delta):
	# Move for some time, think about choosing apply_force or changing position...
	#position += delta*move_speed*direction_vector
	#apply_central_force(direction_vector*move_speed)
	#move_speed = lerp(move_speed, 0.0, move_dampening)
	
	if (is_explosion_ongoing):
		#deal damage
		#explosion_circle.global_position = position
		apply_damage()
	
func _start_countdown():
	explosion_timer.start(time_to_explode)
	animation_player.play("bomb_pre_explosion")

func _on_explosion_timer_timeout():
	explode()
	

func apply_damage():
	var entities = get_tree().get_nodes_in_group("Entities")
	for entity in entities:
		var hit_direction : Vector2 = entity.position - position
		var distance = hit_direction.length()
		if distance <= explosion_range:
			print("Damage ", entity.name)
			if "hit" in entity:
				entity.hit(damage, hit_direction)

func explode():
	print("Explosion!!!")
	explosion_circle.explosion_radius = explosion_range
	explosion_circle.visible = true
	bomb_sprite.visible = false
	bomb_collision_shape.disabled = true
	explosion_particles.emitting = true
	is_explosion_ongoing = true
	explosion_duration_timer.start(explosion_duration)

func _on_explosion_duration_timer_timeout():
	queue_free()
