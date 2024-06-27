extends BossBase
class_name PorcupineBoss
var can_shoot_spikes : bool = true

@export var spike_scene : PackedScene
@onready var animation_tree = $Animations/AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var spike_shot_timer = $Timers/SpikeShotTimer
var spike_shot_cooldown : float = 0.25
### Shoot: what, from, what direction
signal shoot_spike(spike: EnemyProjectile, pos: Vector2, dir : Vector2)

func process_state():
	var dest = Vector2.INF
	match current_state:
		ENEMY_STATE.IDLE:
			velocity = Vector2.ZERO
			dest = Vector2.INF
		ENEMY_STATE.WALK:
			flip_sprite_direction(move_direction)
			velocity = move_direction * move_speed
			move_and_slide()
		ENEMY_STATE.AGGRO:
			move_direction = (Globals.player_pos - position).normalized()
			flip_sprite_direction(move_direction)
			velocity = move_direction * move_speed
			move_and_slide()
			if can_shoot_spikes:
				current_state = ENEMY_STATE.SHOOT_BASIC
				can_shoot_spikes = false
				
				
		ENEMY_STATE.SHOOT_BASIC:
			print("Shooting spike")
			state_machine.travel("porcupine_boss_shoot_right")
			await animation_tree.animation_finished
			pick_new_state()
				

func pick_new_state():
	match current_state:
		ENEMY_STATE.IDLE:
			state_machine.travel("porcupine_boss_walk_right")
			print("FromIdleToAggro")
			current_state = ENEMY_STATE.AGGRO
			select_new_direction()
		
		ENEMY_STATE.AGGRO:
			print("FromAggroToIdle")
			state_machine.travel("porcupine_boss_idle_right")
			current_state = ENEMY_STATE.IDLE
			destination = Vector2.INF
			
		ENEMY_STATE.SHOOT_BASIC:
			print("FromSHOOT_BASICToAGGRO")
			stop_timers()
			# Cooldown starts after egg is placed finishes
			spike_shot_timer.start(spike_shot_cooldown)
			state_machine.travel("porcupine_boss_idle_right")
			current_state = ENEMY_STATE.IDLE
			#idle_timer.start(idle_time)


func _on_shoot_spike_single():
	# send info
	#move_direction
	var spike = spike_scene.instantiate() as EnemyProjectile
	
	var dist = global_position.distance_to(Globals.player_pos)
	var shoot_pos = Globals.player_pos + Globals.player_velocity * (dist/spike.speed)
	var shoot_dir = (shoot_pos - global_position).normalized()
	
	shoot_spike.emit(spike, position, shoot_dir)
	print("Single spike")
	pass
	


func _on_spike_shot_timer_timeout():
	can_shoot_spikes = true
