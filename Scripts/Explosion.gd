extends Area2D

export var power = 1.5
export var PLAYER_POWER_MODIFIER = .2

var bodies

func _ready():
	$Sprite.set_scale(Vector2(.1, .1))
	pass

func _process(delta):
	#Grow
	$Sprite.set_scale($Sprite.get_scale()*1.2)

	#Fade out
	set_modulate(Color(1,1,1, 3-$Sprite.get_scale().x ))

	#If too big, die
	if $Sprite.get_scale().x > 3:
		queue_free()

	#Collision/Knockback
	bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_class() == 'KinematicBody2D':
			if body.name == 'Player':
				body.vel += (body.get_position() - get_position()) * power * PLAYER_POWER_MODIFIER
			else:
				body.vel += (body.get_position() - get_position()) * power