extends BossBase
class_name ChickenBoss
@onready var lay_egg_timer = $Timers/LayEggTimer

@onready var animation_player = $Animations/AnimationPlayer
@onready var animation_tree = $Animations/AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var egg_lay_marker = $EggLayMarker

@export var egg_scene : PackedScene

@export var lay_egg_cooldown : float = 3.0

var can_lay_egg : bool = true

signal spawned_egg(egg : HatchingEgg, pos : Vector2)
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
			if can_lay_egg:
				print("Laying egg")
				current_state = ENEMY_STATE.LAY_EGG
				can_lay_egg = false
				
				
		ENEMY_STATE.LAY_EGG:
			print("Laying egg")
			state_machine.travel("chicken_boss_lay_egg_right")
			await animation_tree.animation_finished
			pick_new_state()
				

func pick_new_state():
	match current_state:
		ENEMY_STATE.IDLE:
			state_machine.travel("chicken_boss_walk_right")
			print("FromIdleToAggro")
			current_state = ENEMY_STATE.AGGRO
			select_new_direction()
		
		ENEMY_STATE.AGGRO:
			print("FromAggroToIdle")
			state_machine.travel("chicken_boss_idle_right")
			current_state = ENEMY_STATE.IDLE
			destination = Vector2.INF
			
		ENEMY_STATE.LAY_EGG:
			print("FromLayEggToAGGRO")
			stop_timers()
			# Cooldown starts after egg is placed finishes
			lay_egg_timer.start(lay_egg_cooldown)
			state_machine.travel("chicken_boss_idle_right")
			current_state = ENEMY_STATE.IDLE
			#idle_timer.start(idle_time)
		
			
func _on_lay_egg_timer_timeout():
	can_lay_egg = true

func _on_spawn_egg():
	var egg = egg_scene.instantiate() as HatchingEgg
	spawned_egg.emit(egg, egg_lay_marker.global_position)

