extends Door

func open_door():
	if !is_open:
		is_open = true
		$AnimationPlayer.play("door_open")
		await $AnimationPlayer.animation_finished
		print("Door opened")
