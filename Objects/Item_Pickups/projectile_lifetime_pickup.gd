extends ItemPickup

@export var projectile_liftime_increase : float = 0.5


func _on_body_entered(body):
	if !is_picked_up:
		Globals.projectile_lifetime += projectile_liftime_increase
		is_picked_up = true
		audio_player.play()
		hide()
		await audio_player.finished
		queue_free()
