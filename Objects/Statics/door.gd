extends Area2D

class_name Door
var is_open : bool = false


func open_door():
	if !is_open:
		is_open = true
		$AnimationPlayer.play("door_open")
		await $AnimationPlayer.animation_finished
		print("Door opened")
