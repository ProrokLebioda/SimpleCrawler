extends Area2D

var direction_vector : Vector2 = Vector2.ZERO
@export var speed : int = 200
@export var projectile_lifetime : float = 4

func _ready():
	$SelfDestructionTimer.start(projectile_lifetime)
	
func _physics_process(delta):
	position+= direction_vector*speed*delta
	
func _on_body_entered(body):
	#print(body.name)
	if "hit" in body:
		body.hit()
	queue_free()

func _on_self_destruction_timer_timeout():
	queue_free()
