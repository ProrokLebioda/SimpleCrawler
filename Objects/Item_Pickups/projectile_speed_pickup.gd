extends ItemPickup

@export var projectile_speed_increase : float = 10.0

func _on_body_entered(body):
	if !is_picked_up:
		Globals.projectile_speed += projectile_speed_increase
		is_picked_up = true
		audio_player.play()
		hide()
		await audio_player.finished
		queue_free()

