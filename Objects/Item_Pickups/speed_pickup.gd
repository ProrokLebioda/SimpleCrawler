extends ItemPickup

@export var speed_boost : float = 20.0

func _on_body_entered(body):
	if !is_picked_up:
		Globals.movement_speed += speed_boost
		is_picked_up = true
		audio_player.play()
		hide()
		await audio_player.finished
		queue_free()
