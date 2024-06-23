extends BossBase
class_name PerunBoss
@export var lightning_rod_scene : PackedScene

@onready var animation_player = $Animations/AnimationPlayer
@onready var animation_tree = $Animations/AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

#Timers
@onready var lightning_rod_attack_timer = $Timers/LightningRodAttackTimer
@onready var lightning_spear_attack_timer = $Timers/LightningSpearAttackTimer


# Attack stuff, should rename 'spear' to 'arc', otherwise it's going to bite me in the a**
var can_lightning_rod_attack : bool = true
var can_lightning_spear_attack : bool = true
@export var lightning_rod_cooldown : float = 3
@export var lightninig_spear_cooldown : float = 5
@onready var lightning_arc = $LightningArc


# Too coupled, but would require some changes that I don't want to do 
signal spawn_boss_rod_attack(lightning_rod : LightningRodAttack, pos : Vector2)

@export var temp_position_offset : Vector2 = Vector2(10,10)

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
			
			if can_lightning_spear_attack:
				current_state = ENEMY_STATE.SHOOT_SPECIAL
				can_lightning_spear_attack = false
			elif can_lightning_rod_attack:
				current_state = ENEMY_STATE.SHOOT_BASIC
				can_lightning_rod_attack = false
			
				
		ENEMY_STATE.SHOOT_BASIC:
			print("Shooting")
			state_machine.travel("perun_throw_lightning_rod")
			await animation_tree.animation_finished
			pick_new_state()
		
		ENEMY_STATE.SHOOT_SPECIAL:
			print("Special shot")
			state_machine.travel("perun_lightning_spear_attack")
			await animation_tree.animation_finished
			lightning_arc.has_target = false
			lightning_arc.queue_redraw()
			pick_new_state()

func pick_new_state():
	match current_state:
		ENEMY_STATE.IDLE:
			state_machine.travel("perun_walk")
			print("FromIdleToAggro")
			current_state = ENEMY_STATE.AGGRO
			select_new_direction()
		
		ENEMY_STATE.AGGRO:
			print("FromAggroToIdle")
			state_machine.travel("perun_idle")
			current_state = ENEMY_STATE.IDLE
			destination = Vector2.INF
			
		ENEMY_STATE.SHOOT_BASIC:
			print("FromSHOOT_BASICToAGGRO")
			stop_timers()
			# Cooldown starts after egg is placed finishes
			lightning_rod_attack_timer.start(lightning_rod_cooldown)
			state_machine.travel("perun_idle")
			current_state = ENEMY_STATE.IDLE
			#idle_timer.start(idle_time)
		ENEMY_STATE.SHOOT_SPECIAL:
			print("FromSHOOT_SPECIALToAGGRO")
			stop_timers()
			# Cooldown starts after egg is placed finishes
			lightning_spear_attack_timer.start(lightninig_spear_cooldown)
			state_machine.travel("perun_idle")
			current_state = ENEMY_STATE.IDLE
			#idle_timer.start(idle_time)


func throw_lightning_rod():
	print("Perun threw lightning rod")
	var player_pos = Globals.player_pos
	# temp
	var lightning_rod_pos = player_pos + temp_position_offset
	var lightning_rod = lightning_rod_scene.instantiate() as LightningRodAttack
	spawn_boss_rod_attack.emit(lightning_rod, lightning_rod_pos)

func attack_lightning_spear():
	print("Perun attacks with lightning spear")
	# how to (maybe) do this?
	# 1. Get all LightningRods
	# 2. Find closest to Perun
	# 3. Shoot a beam (later change to lightning) into it, check it as 'visited' (don't loop)
	# 4. Trigger aoe shock, use similar logic to bomb, draw lightning tendrils going outside (draw a faint background circle to show where damage zone is)
	# 5. Hop into next neighbour
	# 6. Repeat 4-5 until no unvisited neighbours
	
	#1.
	var all_rods = get_tree().get_nodes_in_group("BossAttack")
	var min_distance : float = 1000000.0
	var closest_rod : LightningRodAttack = null
	# 2. Closest distance to player maybe?
	for rod in all_rods:
		#var dist_perun_to_rod = position.distance_to(rod.global_position)
		#var dist_player_to_rod = Globals.player_pos.distance_to(rod.global_position)
		#if dist_player_to_rod < min_distance:
		#	closest_rod = rod
		#	min_distance = dist_player_to_rod
			
		var dist_perun_to_rod = global_position.distance_to(rod.global_position)
		if dist_perun_to_rod < min_distance:
			closest_rod = rod
			min_distance = dist_perun_to_rod
	
	if closest_rod:
		print("Closest rod is: ", closest_rod.name)
		lightning_arc.target_pos = closest_rod.global_position
		lightning_arc.has_target = true
		lightning_arc.queue_redraw()
		closest_rod.is_visited = true
		closest_rod.trigger_electric_discharge()
		
	for rod in all_rods:
		# Clear 'visited' state to allow them to trigger next time
		#rod.is_visited = false
		pass

func _on_lightning_rod_attack_timer_timeout():
	can_lightning_rod_attack = true

func _on_lightning_spear_attack_timeout():
	can_lightning_spear_attack = true
