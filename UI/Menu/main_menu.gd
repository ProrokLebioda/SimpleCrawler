extends CanvasLayer
@onready var settings_menu = $settings_menu
@onready var main_menu = $Control
@onready var new_game_button = $Control/VBoxContainer/NewGameButton
@onready var settings_button = $Control/VBoxContainer/SettingsButton
@onready var settings_back_button = $settings_menu/SettingsMenu/MarginContainer/VBoxContainer/BackButton

func _ready():
	if (get_tree().paused):
		get_tree().paused = false
	new_game_button.grab_focus()

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
	settings_menu.visible = !settings_menu.visible
	if settings_back_button.visible:
		settings_back_button.grab_focus()
	
	main_menu.visible = !main_menu.visible
	if main_menu.visible:
		settings_button.grab_focus()
		
