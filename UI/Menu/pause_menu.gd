extends CanvasLayer
@onready var settings_menu = $settings_menu
@onready var pause_menu = $PauseMenuLayout
@onready var level = $"../.."
@onready var continue_button = $PauseMenuLayout/VBoxContainer/ContinueButton
@onready var settings_button = $PauseMenuLayout/VBoxContainer/SettingsButton
signal unpause


func _input(event):
	if event.is_action_pressed("escape"):
		_on_pause()	

func _on_back_button_pressed():
	settings_menu.visible = !settings_menu.visible

func toggle_settings():
	settings_menu.visible = !settings_menu.visible
	if settings_menu.visible:
		$settings_menu/SettingsMenu/MarginContainer/VBoxContainer/BackButton.grab_focus()
	
	pause_menu.visible = !pause_menu.visible 
	if pause_menu.visible:
		settings_button.grab_focus()


func _on_settings_button_pressed():
	toggle_settings()


func _on_pause():
	unpause.emit()
	visible = !visible
	if pause_menu.visible:
		continue_button.grab_focus()
