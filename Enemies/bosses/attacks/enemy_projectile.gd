extends Area2D
class_name EnemyProjectile

var direction_vector : Vector2 = Vector2.ZERO
@export var speed : int = 200
@export var projectile_lifetime : float = 4
@export var projectile_damage : int = 2

func _ready():
	$SelfDestructionTimer.start(projectile_lifetime)
	
func _physics_process(delta):
	position+= direction_vector * speed * delta
	
func _on_body_entered(body):
	var bullet_pos = position
	# get direction to centre of other body, from bullet to body
	var body_pos = body.position
	var hit_direction = (body_pos-bullet_pos).normalized()
	
	#print(body.name)
	if "hit" in body:
		body.hit(projectile_damage,hit_direction)
	queue_free()

func _on_self_destruction_timer_timeout():
	queue_free()
