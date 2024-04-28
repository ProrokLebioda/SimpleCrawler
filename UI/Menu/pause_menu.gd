extends CanvasLayer

func _input(event):
	if event.is_action_pressed("escape"):
		pause()

func pause():
	get_tree().paused = !get_tree().paused
	visible = visible
