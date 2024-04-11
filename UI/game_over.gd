extends CanvasLayer


func _on_retry_button_pressed():
	Globals.reset_player_stats()
	get_tree().change_scene_to_file("res://Levels/starting_level.tscn")
	



func _on_quit_button_pressed():
	get_tree().quit()