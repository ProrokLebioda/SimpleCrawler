extends Node2D
class_name WeaponBase

@onready var bullet_scene : PackedScene = preload("res://Characters/Player/Weapons/Bullets/bullet.tscn")

var weapon_name : String = "WeaponBase"
@export var weapon_enum : Weapons.WeaponName = Weapons.WeaponName.BASIC

func fire(pos: Vector2, dir: Vector2) -> Array[BulletBase]:
	print("Weapon name: ", weapon_name)
	var bullet = bullet_scene.instantiate() as BulletBase
	bullet.position = pos
	bullet.rotation_degrees = rad_to_deg(dir.angle()) + 90.0
	bullet.direction_vector = dir
	
	var bullets: Array[BulletBase] = [bullet]
	return bullets
