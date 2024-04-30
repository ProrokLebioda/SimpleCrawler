extends ItemStand

var health_pickup_scene: PackedScene = preload("res://Objects/Item_Pickups/health_pickup.tscn")
@onready var collision_shape_2d = $CollisionShape2D
@export var item_price : int = 3
@onready var item_spot = $ItemSpot

func _ready():
	if is_used: 
		collision_shape_2d.set_deferred("disabled", true)
	else:
		var item = health_pickup_scene.instantiate()
		item.position = item_spot.position
		item_spot.add_child(item)

func _on_stand_pay_area_body_entered(body):
	print(body.name, " entered to pay")
	if !is_used: 
		if Globals.coins >= item_price:
			Globals.coins -= item_price
			collision_shape_2d.set_deferred("disabled", true)
			is_used = true
