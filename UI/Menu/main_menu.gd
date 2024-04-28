extends CanvasLayer
@onready var settings_menu = $settings_menu
@onready var main_menu = $Control

func _ready():
	if (get_tree().paused):
		get_tree().paused = false

func _on_new_game_button_pressed():
	Globals.reset_player_stats()
	get_tree().change_scene_to_file(Room.starting_room)
	
func _on_quit_button_pressed():
	get_tree().quit()

func _on_settings_button_pressed():
	toggle_settings()

func _on_back_button_pressed():
	toggle_settings()

func toggle_settings():
	main_menu.visible = !main_menu.visible
	settings_menu.visible = !settings_menu.visible
