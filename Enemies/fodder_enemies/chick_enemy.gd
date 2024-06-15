extends SimpleEnemy


func _physics_process(delta):
	
	var new_velocity: Vector2 = Vector2.ZERO
	if knockback_force > 0:
		knockback_val = knockback_direction * knockback_force
	if (current_state == ENEMY_STATE.AGGRO):
		navigation_agent_2d.target_position = Globals.player_pos
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()

		new_velocity = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		flip_sprite_direction(new_velocity) # has to be new_velocity normalized()
		new_velocity = knockback_val+new_velocity * move_speed
		velocity = new_velocity
		move_and_slide()
		

	if (current_state == ENEMY_STATE.WALK):
		velocity = move_direction * move_speed + knockback_val
		move_and_slide()
	elif current_state == ENEMY_STATE.IDLE:
		if (knockback_force > 0):
			velocity = knockback_val
			move_and_slide()
		else:
			velocity = Vector2.ZERO

	knockback_force = lerp(knockback_force, 0.0, 0.1)
#	if knockback_component:
#		pass

func pick_new_state():
	match current_state:
		ENEMY_STATE.IDLE:
			state_machine.travel("chicken_walk_right")
			print("ToWalk")
			current_state = ENEMY_STATE.WALK
			select_new_direction()
			idle_walk_timer.start(walk_time)
		
		ENEMY_STATE.WALK:
			state_machine.travel("chicken_idle_right")
			print("ToIdle")
			current_state = ENEMY_STATE.IDLE
			idle_walk_timer.start(idle_time)
		
		ENEMY_STATE.AGGRO:				
			state_machine.travel("chicken_idle_right")
			current_state = ENEMY_STATE.IDLE
			idle_walk_timer.start(idle_time)
			

func _on_notice_area_body_entered(body):
	print("Body entered ",body.name )
	state_machine.travel("chicken_walk_right")
	if (idle_walk_timer.time_left > 0):
		idle_walk_timer.stop()
		
	if (aggro_lose_timer.time_left > 0):
		aggro_lose_timer.stop()

	current_state = ENEMY_STATE.AGGRO

func _on_notice_area_body_exited(body):
	if (current_state == ENEMY_STATE.AGGRO):
		if aggro_lose_timer.is_inside_tree():
			aggro_lose_timer.start(aggro_lose_time)
			print ("Aggro lose timer started")
		
func _on_idle_walk_timer_timeout():
	if (current_state != ENEMY_STATE.AGGRO):
		pick_new_state()


func _on_aggro_lose_timer_timeout():
	pick_new_state()
	print ("Aggro lost")


func _on_damage_area_body_entered(body):
	
	if body is CharacterBody2D:
		print("Damage area entered: ", body.name)
		var enemy_pos = position
		# get direction to centre of other body, from enemy to body
		var body_pos = body.position
		var hit_direction = (body_pos-enemy_pos).normalized()
	
		if "hit" in body:
			body.hit(base_damage, hit_direction)

func _on_hit_timer_timeout():
	vulnerable = true
	sprite.material.set_shader_parameter("progress", 0)
