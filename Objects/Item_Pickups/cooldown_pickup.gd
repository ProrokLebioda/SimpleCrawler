extends ItemPickup

@export var cooldown_reduction : float = 0.1


func _on_body_entered(body):
	if !is_picked_up:
		Globals.shoot_cooldown -= cooldown_reduction
		is_picked_up = true
		audio_player.play()
		hide()
		await audio_player.finished
		queue_free()
