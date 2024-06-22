extends Area2D

signal hit_rod(damage : int, dir: Vector2)

func hit(damage : int, dir: Vector2):
	hit_rod.emit(damage, dir)
