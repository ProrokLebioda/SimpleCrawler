extends CanvasLayer
@export var death_music: AudioStream
@onready var retry_button = $VBoxContainer/RetryButton


func _ready():
	AudioPlayer._play_music(death_music, -12.0)
	retry_button.grab_focus()

func _on_retry_button_pressed():
	Globals.reset_player_stats()
	get_tree().change_scene_to_file(Room.starting_room)
	



func _on_quit_button_pressed():
	get_tree().quit()


func _on_main_menu_button_pressed():
	AudioPlayer._stop_music()
	get_tree().change_scene_to_file("res://UI/Menu/main_menu.tscn")
