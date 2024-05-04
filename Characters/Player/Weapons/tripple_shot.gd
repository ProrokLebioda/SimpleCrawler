extends WeaponBase

func _ready():
	weapon_name = "TrippleShot"
	

func fire(pos: Vector2, dir: Vector2) -> Array[BulletBase]:
	print("Weapon name: ", weapon_name)
	var bullet1 = bullet_scene.instantiate() as BulletBase
	bullet1.position = pos
	bullet1.rotation_degrees = rad_to_deg(dir.angle()) + 90.0
	bullet1.direction_vector = dir
	
	var bullet2 = bullet_scene.instantiate() as BulletBase
	bullet2.position = pos
	bullet2.rotation_degrees = rad_to_deg(dir.angle()) + 90.0
	#bullet2.direction_vector = dir 
	var ang2 = deg_to_rad((bullet1.rotation_degrees) - 85.0)
	bullet2.direction_vector = Vector2.from_angle(ang2)
	
	var bullet3 = bullet_scene.instantiate() as BulletBase
	bullet3.position = pos
	var ang3 = deg_to_rad((bullet1.rotation_degrees) - 95.0)
	bullet3.direction_vector = Vector2.from_angle(ang3)
	
	var bullets : Array[BulletBase] = [bullet1, bullet2, bullet3]
	return bullets
