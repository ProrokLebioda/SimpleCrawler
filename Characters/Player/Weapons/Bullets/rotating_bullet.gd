extends BulletBase

@export var rotation_amount_degrees: float = 5.0
# This moves sprite and collider on X axis, it enables 'rotation around centre'
@export var rotation_radius: float = 10.0
@onready var sprite_2d = $Sprite2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	super()
	sprite_2d.move_local_x(rotation_radius)
	collision_shape_2d.move_local_x(rotation_radius)
	
func _physics_process(delta):
	rotate(deg_to_rad(rotation_amount_degrees))
	position+= direction_vector*speed*delta
	
func _on_body_entered(body):
	var bullet_pos = position
	# get direction to centre of other body, from bullet to body
	var body_pos = body.position
	var hit_direction = (body_pos-bullet_pos).normalized()
	
	#print(body.name)
	if "hit" in body:
		body.hit(projectile_damage, hit_direction)
	queue_free()

func _on_self_destruction_timer_timeout():
	queue_free()
