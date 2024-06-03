extends CanvasLayer
@onready var new_game_button = $VBoxContainer/NewGameButton



#change to something more fitting than robot
@export var victory_music: AudioStream
func _ready():
	AudioPlayer._play_music(victory_music, -12.0)
	new_game_button.grab_focus()
	
func _on_new_game_button_pressed():
	Globals.reset_player_stats()
	get_tree().change_scene_to_file(Room.starting_room)
	
func _on_main_menu_button_pressed():
	Globals.reset_player_stats()
	get_tree().change_scene_to_file("res://UI/Menu/main_menu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
