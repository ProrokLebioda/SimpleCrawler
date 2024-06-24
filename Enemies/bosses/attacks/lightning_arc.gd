extends Node2D

var white : Color = Color.WHITE
@export var line_color : Color = Color(1, 1, 1, 0.4)
var godot_blue : Color = Color("478cbf")
var grey : Color = Color("414042")

@export var line_width : float = 1.0
var target_pos : Vector2
var has_target : bool = false

# Rendering lightning stuff
@export var sub_forkify : bool = false
@export var lightning_line_scene : PackedScene

var fork_count : int = 1
var sub_fork_count : int = 10

var forks_array : Array = []
var sub_fork_length : float = 15

var mouse_position : Vector2
var from_to : Vector2
var normal : Vector2
var fork_offset : float = 30
var target : Vector2
var length_offset : float = 1
##
@onready var lightnings = $Lightnings

func _draw():
	forks_array.clear()
	var all_arcs = lightnings.get_children()
	for arc in all_arcs:
		arc.queue_free()
	if has_target:
		
		# Position has to be calculated, because drawing is happening based on current parent node position, meaning we need to substract current global position to get relative position
		var pos = target_pos - global_position
		#draw_line(Vector2(0,0), pos, line_color, line_width, true)



		## Fancy lightning
		var lightning_instance : Line2D = lightning_line_scene.instantiate()
		for fork in range(0, fork_count):
			if fork == 0:
				target = pos
			else:
				length_offset =randf()
				target = (pos + normal * randf_range(-fork_offset,fork_offset)) * length_offset
			
			from_to = target #- global_position#change global to 0,0
			if sub_forkify:
				sub_fork_count = from_to.length()/40
				sub_fork_length = from_to.length()/5
			normal = Vector2(from_to.y, -from_to.x).normalized()
			lightnings.add_child(lightning_instance)
			lightning_instance.set_start(Vector2(0,0))#global_position)#change global to 0,0
			lightning_instance.set_end(target)
			lightning_instance.segmentize(from_to,Vector2(0,0))#global_position)#change global to 0,0
			lightning_instance.sway_func(normal)
			#yield(get_tree(), "idle_frame")
			#lightning_line.animation_player.
			forks_array.append(lightning_instance)
			if sub_fork_count > 0:
				for sub_fork in range(0, sub_fork_count):
					var picked_fork : Line2D = forks_array[int(randi_range(0,(forks_array.size() - 1 )))]
					sub_forkify_func(normal, picked_fork.get_point_position(randi_range(0, picked_fork.get_point_count() - 1)))


func sub_forkify_func(normal : Vector2, point : Vector2) -> void:
	var lightning_instance : Line2D = lightning_line_scene.instantiate()
	var sub_target : Vector2 = (point + normal * randf_range(-sub_fork_length, sub_fork_length)) + (target/4) * randf()
	var sub_from_to = sub_target - point
	var sub_normal : Vector2 = Vector2(sub_from_to.y, -sub_from_to.x).normalized()
	lightnings.add_child(lightning_instance)
	lightning_instance.set_start(point)#change global to 0,0
	lightning_instance.set_end(sub_target)
	lightning_instance.segmentize(sub_from_to,point)#change global to 0,0
	lightning_instance.sway_func(sub_normal)
	pass
