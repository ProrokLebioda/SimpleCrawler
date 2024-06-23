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

# Electric discharge stuff
@onready var electric_discharge_timer = $ElectricDischargeTimer
@onready var damage_interval_timer = $DamageIntervalTimer
@export var damage_interval_time : float = 0.3
@onready var explosion_circle = $ExplosionCircle
@export var electric_discharge_damage : int = 2
@export var electric_discharge_cooldown : float = 2.0 # perhaps this is unnecessary, because it's going to be triggered only by Perun
@onready var discharge_area = $DischargeArea
@onready var discharge_area_collision = $DischargeArea/CollisionShape2D
var discharge_area_radius : float = 0.0
var can_damage : bool = true
var can_electric_discharge : bool = true
var is_discharging : bool = false
@onready var lightning_arc = $LightningArc

# This needs to be reset after triggering by boss, initial visit will be trigger by Perun, subsequent by itself
var is_visited : bool = false

var move_direction : Vector2 = Vector2.ZERO
@export var death_particle : PackedScene

# Pushback 
var knockback_direction: Vector2 = Vector2.ZERO
var knockback_force: float = 100.0
var knockback_val: Vector2 = Vector2.ZERO

func _ready():
	discharge_area_radius = discharge_area_collision.shape.radius
	animation_player.play("lightning_rod_drop")
	hitbox.connect("hit_rod", hit)
	
	# Temp:
	#trigger_electric_discharge()

func _physics_process(delta):
	if knockback_force > 0:
		knockback_val = knockback_direction * knockback_force
		position += knockback_val * delta
		
	
	knockback_force = lerp(knockback_force, 0.0, 0.1)
	
	if is_discharging and can_damage:
		damage_interval_timer.start(damage_interval_time)
		can_damage = false
		apply_damage()

func trigger_electric_discharge():
	if can_electric_discharge:
		can_electric_discharge = false
		electric_discharge_timer.start(electric_discharge_cooldown)
		# Remove line below, trigger from animation?
		is_discharging = true
		
		# Propagate
		propagate_arc()
		
		explosion_circle.explosion_radius = discharge_area_radius
		animation_player.play("lightning_rod_electric_discharge")
		await animation_player.animation_finished
		is_discharging = false
		lightning_arc.has_target = false
		lightning_arc.queue_redraw()
		is_visited = false

func propagate_arc():
	var all_rods = get_tree().get_nodes_in_group("BossAttack")
	var min_distance : float = 1000000.0
	var closest_rod : LightningRodAttack = null
	for rod in all_rods:
		if rod == self:
			continue
		if rod.is_visited == false:
			var dist = global_position.distance_to(rod.global_position)
			if dist < min_distance:
				min_distance = dist
				closest_rod = rod
	
	if closest_rod:
		print("Closest rod: " , closest_rod.name, " is visited?:", closest_rod.is_visited)
		closest_rod.is_visited = true
		lightning_arc.has_target = true
		lightning_arc.target_pos = closest_rod.global_position
		closest_rod.trigger_electric_discharge()
		lightning_arc.queue_redraw()

func apply_damage():
	var entities = get_tree().get_nodes_in_group("Player")
	for entity in entities:
		var hit_direction : Vector2 = entity.position - position
		var distance = hit_direction.length()
		if distance <= discharge_area_radius:
			print("Damage ", entity.name)
			if "hit" in entity:
				entity.hit(electric_discharge_damage, hit_direction)

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


func _on_electric_discharge_timer_timeout():
	can_electric_discharge = true


func _on_damage_interval_timer_timeout():
	can_damage = true
