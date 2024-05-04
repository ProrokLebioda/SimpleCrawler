extends ItemPickup

@onready var weapon_enum : Weapons.WeaponName = Weapons.WeaponName.ROTATING
func _on_body_entered(body):
	if !is_picked_up:
#		Globals.health += healing_power
		var weapon_scene = Weapons.weapons[weapon_enum]
		var weapon = weapon_scene.instantiate()
		Globals.current_weapon = weapon
		is_picked_up = true
		audio_player.play()
		hide()
		await audio_player.finished
		queue_free()
