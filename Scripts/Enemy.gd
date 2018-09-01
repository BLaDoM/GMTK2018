extends KinematicBody2D

export var SPEED = 20

var type = 'Enemy'
export var enemy_type = 'Basic'
export var can_fly = false
var vel = Vector2()
var dir = 1
var health = 1
var bob = 1

func _ready():
	#Initialize bobbing
	randomize()
	bob = randf()*2 / 2

	vel = Vector2(0, 500)
	health = 1
	if enemy_type == 'Tank':
		health = 4
		set_scale(Vector2(1.2, 1.2))
	if can_fly == true:
		vel = Vector2(0, 0)
	pass

func _physics_process(delta):
	if health <= 0:
		die()

	if enemy_type == 'Basic'  and !can_fly:
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

	#Bobbing sprite
	$Sprite.set_position(Vector2(0, cos(get_position().x/5)*2))
	if can_fly:
		$Sprite.set_position(Vector2(0, cos(bob)))
		bob += .1

func die():
	queue_free()