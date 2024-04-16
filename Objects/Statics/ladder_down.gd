extends Node2D

signal player_entered_ladder


func _on_area_2d_body_entered(body):
	print("Entered: ", body.name)
	player_entered_ladder.emit()
