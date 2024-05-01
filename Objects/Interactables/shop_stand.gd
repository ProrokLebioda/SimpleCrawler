extends ItemStand

@onready var collision_shape_2d = $CollisionShape2D
@onready var item_spot = $ItemSpot
@onready var item_price_text = $ItemPriceText

@export var health_pickup_scene: PackedScene = preload("res://Objects/Item_Pickups/health_pickup.tscn")
@export var item_price : int = 3

func _ready():
	if is_used: 
		collision_shape_2d.set_deferred("disabled", true)
		item_price_text.visible = false
	else:
		var item = health_pickup_scene.instantiate()
		item.position = item_spot.position
		item_spot.add_child(item)
		item_price_text.visible = true
		item_price_text.set_text(str(item_price))

func _on_stand_pay_area_body_entered(body):
	print(body.name, " entered to pay")
	if !is_used: 
		if Globals.coins >= item_price:
			Globals.coins -= item_price
			collision_shape_2d.set_deferred("disabled", true)
			is_used = true
			item_price_text.visible = false