extends RoomParent
@onready var instruction_sprite = $InstructionSprite

func _ready():
	super()
	if room_vector_position == Vector3i.ZERO:
		print("Start of start")
		instruction_sprite.visible = true
