extends CanvasLayer

#colors
var green: Color = Color("#6bbfa3")
var red: Color = Color(0.9,0,0.1)

@onready var health_bar : TextureProgressBar = $HealthContainer/HBoxContainer/MarginContainer/TextureProgressBar

func _ready():
	Globals.connect("stat_change", update_stat_text)
	update_stat_text()
	
func update_stat_text():
	update_health_text()
	
func update_health_text():
	health_bar.value = Globals.health
