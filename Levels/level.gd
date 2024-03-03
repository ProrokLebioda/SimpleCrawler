extends Node2D

var bullet_scene : PackedScene = preload("res://Characters/Player/bullet.tscn")


func _on_player_shoot_input_detected(pos, dir):
	var bullet = bullet_scene.instantiate() as Area2D
	bullet.position = pos
	bullet.rotation_degrees = rad_to_deg(dir.angle()) + 90.0
	bullet.direction_vector = dir
	$Projectiles.add_child(bullet)
