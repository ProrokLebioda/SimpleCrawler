extends ItemPickup

@export var coin_amount: float = 2




func _on_body_entered(body):
	if !is_picked_up:
		Globals.coins += coin_amount
		is_picked_up = true
		audio_player.play()
		hide()
		await audio_player.finished
		queue_free()
