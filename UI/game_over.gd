extends CanvasLayer
@export var death_music: AudioStream

func _ready():
	AudioPlayer._play_music(death_music, -12.0)


func _on_retry_button_pressed():
	Globals.reset_player_stats()
	get_tree().change_scene_to_file(Room.starting_room)
	



func _on_quit_button_pressed():
	get_tree().quit()
