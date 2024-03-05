extends CharacterBody2D
enum ENEMY_STATE {IDLE, WALK}

var active : bool = false

@export var move_speed : float = 30
@export var idle_time : float = 2
@export var walk_time : float = 2


@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer


var move_direction : Vector2 = Vector2.ZERO
var current_state : ENEMY_STATE = ENEMY_STATE.IDLE

func _ready():
	pick_new_state()
	
func _physics_process(delta):
	if (active):
		move_direction = (Globals.player_pos - position).normalized()
	if (current_state == ENEMY_STATE.WALK):
		velocity = move_direction * move_speed
		move_and_slide()
		


func _on_notice_area_body_entered(body):
	print("Body entered ",body.name )
	active = true
	if (current_state != ENEMY_STATE.WALK):
		#current_state = ENEMY_STATE.WALK
		pick_new_state()
	
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	
	if (move_direction.x < 0):
		sprite.flip_h = true
	elif(move_direction.x > 0):
		sprite.flip_h = false


func pick_new_state():
	if (current_state == ENEMY_STATE.IDLE):
		state_machine.travel("chicken_walk_right")
		print("ToWalk")
		current_state = ENEMY_STATE.WALK
		select_new_direction()
		timer.start(walk_time)
	elif(current_state == ENEMY_STATE.WALK):
		state_machine.travel("chicken_idle_right")
		print("ToIdle")
		current_state = ENEMY_STATE.IDLE
		timer.start(idle_time)


func _on_timer_timeout():
	if (!active):
		pick_new_state()
