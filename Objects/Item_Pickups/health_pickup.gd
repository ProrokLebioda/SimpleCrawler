extends ItemPickup

@export var healing_power: float = 2

func _on_body_entered(body):
	if !is_picked_up:
		Globals.health += healing_power
		is_picked_up = true
		audio_player.play()
		hide()
		await audio_player.finished
		queue_free()
