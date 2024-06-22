extends StaticBody2D
class_name LightningRodAttack

signal died()

@onready var sprite = $Sprite2D
@onready var hit_timer = $HitTimer

# Damage stuff
@export var health_max : int = 4
@onready var health : int = health_max
var vulnerable : bool = true
var hit_timer_wait_time : float = 0.2
@onready var collider = $Collider
@onready var hitbox = $Hitbox
@onready var animation_player = $AnimationPlayer

var move_direction : Vector2 = Vector2.ZERO
@export var death_particle : PackedScene

# Pushback 
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_force: float = 100.0
var knockback_val: Vector2 = Vector2.ZERO

func _ready():
	animation_player.play("lightning_rod_drop")
	hitbox.connect("hit_rod", hit)

func _physics_process(delta):
	if knockback_force > 0:
		knockback_val = knockback_direction * knockback_force
		position += knockback_val * delta
		
	
	knockback_force = lerp(knockback_force, 0.0, 0.1)

func hit(damage : int, dir: Vector2):
	if vulnerable:
		health -= damage
		vulnerable = false
		$HitTimer.start(hit_timer_wait_time)
		sprite.material.set_shader_parameter("progress", 1)
		
		knockback_direction = dir 
		knockback_force = 0
		if (health <= 0):
			health = 0
#			var particle = death_particle.instantiate()
#			particle.position = global_position
#			particle.rotation = global_rotation
#			particle.emitting = true
#			get_tree().current_scene.add_child(particle)
			animation_player.play("lightning_rod_destroy")
			await animation_player.animation_finished
			
			died.emit(position)
			call_deferred("queue_free")

func _on_hit_timer_timeout():
	vulnerable = true
	sprite.material.set_shader_parameter("progress", 0)


func _on_hitbox_area_entered(area):
	print("rod hit")
