extends AudioStreamPlayer2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_position(get_node("../Bullet").get_position())
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
