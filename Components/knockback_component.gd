extends Node2D
class_name KnockbackComponent
@export var knockback_time: float = 1.5
@export var knockback_force : float = 2.0
@export var knockback_direction : Vector2 = Vector2()

@onready var knockback_timer = $KnockbackTimer

func _ready():
	knockback_timer.start(knockback_time)

func _physics_process(delta):
	knockback_direction = lerp(knockback_direction, Vector2.ZERO, 0.1)
	


