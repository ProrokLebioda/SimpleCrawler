extends ItemPickup

@export var health_increase : int = 4


func _on_body_entered(body):
	if !is_picked_up:
		Globals.max_health += health_increase
		# we want to heal by that amount as well, just to help player
		Globals.health += health_increase
		is_picked_up = true
		audio_player.play()
		hide()
		await audio_player.finished
		queue_free()

