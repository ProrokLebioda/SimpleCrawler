extends StationaryShootingEnemy
	
func process_state():
	match current_state:
		ENEMY_STATE.IDLE:
			pass
		ENEMY_STATE.AGGRO:
			look_direction = (Globals.player_pos - position).normalized()
			flip_sprite_direction(look_direction)
		
			if can_shoot:
				# Shoot
				can_shoot = false
				current_state = ENEMY_STATE.SHOOTING
		ENEMY_STATE.SHOOTING:
			
			state_machine.travel("plant_cannon_plant_cannon_shoot_right")
			await animation_tree.animation_finished
			

func pick_new_state():
	match current_state:
		ENEMY_STATE.IDLE:
			#state_machine.travel("chicken_walk_right")
			state_machine.travel("plant_cannon_plant_cannon_idle_right")
			print("ToIDLE")
			current_state = ENEMY_STATE.AGGRO
			select_new_direction()
		
		ENEMY_STATE.AGGRO:				
			state_machine.travel("plant_cannon_plant_cannon_idle_right")
			current_state = ENEMY_STATE.IDLE
		ENEMY_STATE.SHOOTING:
			state_machine.travel("plant_cannon_plant_cannon_idle_right")
			current_state = ENEMY_STATE.AGGRO
