extends CanvasLayer


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://UI/Menu/main_menu.tscn")
