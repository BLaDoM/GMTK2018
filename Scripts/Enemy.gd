extends KinematicBody2D

export var SPEED = 20

var type = 'Enemy'
var vel = Vector2()
var dir = 1

func _ready():
	vel = Vector2(0, 500)
	pass

func _physics_process(delta):
	if $Right.get_overlapping_bodies().size() and !$Left.get_overlapping_bodies().size():
		dir = 1
	if !$Right.get_overlapping_bodies().size() and $Left.get_overlapping_bodies().size():
		dir = -1
	if $Right2.get_overlapping_bodies().size() and !$Left2.get_overlapping_bodies().size():
		dir = -1
	if !$Right2.get_overlapping_bodies().size() and $Left2.get_overlapping_bodies().size():
		dir = 1
	vel.x += SPEED*dir
	vel.x *= .8
	move_and_slide(vel)