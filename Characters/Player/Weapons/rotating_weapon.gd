extends WeaponBase

func _ready():
	bullet_scene = preload("res://Characters/Player/Weapons/Bullets/rotating_bullet.tscn")
	weapon_name = "RotatingWeapon"

func fire(pos: Vector2, dir: Vector2) -> Array[BulletBase]:
	print("Weapon name: ", weapon_name)
	var bullet1 = bullet_scene.instantiate() as BulletBase
	bullet1.position = pos
	bullet1.rotation_degrees = rad_to_deg(dir.angle()) + 90.0
	bullet1.direction_vector = dir
		
	var bullets : Array[BulletBase] = [bullet1]
	return bullets
