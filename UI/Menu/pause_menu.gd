extends CanvasLayer
@onready var settings_menu = $settings_menu
@onready var pause_menu = $PauseMenuLayout
@onready var level = $"../.."
signal unpause
func _input(event):
	if event.is_action_pressed("escape"):
		_on_pause()	

func _on_back_button_pressed():
	settings_menu.visible = !settings_menu.visible

func toggle_settings():
	settings_menu.visible = !settings_menu.visible
	pause_menu.visible = !pause_menu.visible 


func _on_settings_button_pressed():
	toggle_settings()


func _on_pause():
	unpause.emit()
	visible = !visible
