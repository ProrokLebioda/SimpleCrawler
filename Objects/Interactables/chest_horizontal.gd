extends ItemContainer

func open_up():
	if not is_opened:
		is_opened = true
		$AnimationPlayer.play("open_chest")
		var pos = $SpawnPoints.get_child(randi()%$SpawnPoints.get_child_count()).global_position
		open.emit(pos, current_direction)




func _on_chest_open_area_body_entered(body):
	open_up()
