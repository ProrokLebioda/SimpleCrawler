extends CanvasLayer

@onready var SFX_BUS_ID = AudioServer.get_bus_index(("SFX"))
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index(("Music"))
@onready var music_slider = $SettingsMenu/MarginContainer/VBoxContainer/GridContainer/MusicSlider
@onready var sfx_slider = $SettingsMenu/MarginContainer/VBoxContainer/GridContainer/SFXSlider


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)


func _on_visibility_changed():
	if visible:
		load_slider_values()
		
func load_slider_values():
	var music_value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS_ID))
	var sfx_value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS_ID))
	music_slider.set_value_no_signal(music_value)
	sfx_slider.set_value_no_signal(sfx_value)
