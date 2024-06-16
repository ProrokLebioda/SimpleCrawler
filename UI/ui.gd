extends CanvasLayer

#colors
var green: Color = Color("#6bbfa3")
var red: Color = Color(0.9,0,0.1)

@onready var health_bar : TextureProgressBar = $MarginContainer/StatsContainer/HBoxContainer/MarginContainer/TextureProgressBar
@onready var health_amount_text = $MarginContainer/StatsContainer/HBoxContainer/MarginContainer/HealthAmountText

@onready var level_label = $MarginContainer/StatsContainer/HBoxContainer/LevelLabel
@onready var xp_bar : TextureProgressBar = $MarginContainer/StatsContainer/HBoxContainer/XpBarMarginContainer/TextureProgressBar
@onready var xp_amount_text = $MarginContainer/StatsContainer/HBoxContainer/XpBarMarginContainer/XpAmountText

@onready var special_cooldown_icon = $MarginContainer/StatsContainer/HBoxContainer/SpecialCooldownIcon

@onready var coins_label = $MarginContainer/StatsContainer/HBoxContainer/CoinsLabel

func _ready():
	Globals.connect("stat_change", update_stat_text)
	Globals.connect("special_state_change", update_special_icon_cooldown)
	update_stat_text()
	
func update_stat_text():
	update_health_text()
	update_xp_text()
	update_coins_text()
	
func update_health_text():
	health_bar.set_max(Globals.max_health)
	health_bar.value = Globals.health
	var combined_health_value_display =String(str(Globals.health) + "/" + str(Globals.max_health))
	health_amount_text.set_text(combined_health_value_display)

func update_xp_text():
	var lvl_text = String("LVL: " + str(Globals.level))
	level_label.set_text(lvl_text)
	xp_bar.set_max(Globals.xp_per_level_base*Globals.level)
	xp_bar.value = Globals.xp
	var combined_xp_value_display = String(str(Globals.xp) + "/" + str(Globals.xp_per_level_base*Globals.level))
	xp_amount_text.set_text(combined_xp_value_display)
func update_coins_text():
	coins_label.set_text(str(Globals.coins))

func update_special_icon_cooldown(is_ready):
	if !is_ready:
		special_cooldown_icon.trigger_cooldown(Globals.special_cooldown)
