extends ItemPickup

@export var healing_power: float = 2




func _on_body_entered(body):
	Globals.health += healing_power
	queue_free()
