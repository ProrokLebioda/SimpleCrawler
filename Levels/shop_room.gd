extends RoomParent

func _ready():
	#generate_level() # <=== TODO_Fix: A bandaid for when you enter you need to have info about room, but parent execution is called later which means we don't have correct info about visited state
	super()
