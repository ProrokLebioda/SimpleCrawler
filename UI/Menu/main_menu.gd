extends CanvasLayer

func _ready():
	if (get_tree().paused):
		get_tree().paused = false

func _on_new_game_button_pressed():
	Globals.reset_player_stats()
	get_tree().change_scene_to_file(Room.starting_room)
	

func _on_settings_button_pressed():
	pass

func _on_quit_button_pressed():
	get_tree().quit()
