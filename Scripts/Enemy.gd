extends KinematicBody2D

export var SPEED = 20
export var GRAVITY = 10
export var GROUND_FRICTION = .97
export var AIR_FRICTION = .98
export var WALL_FRICTION = .6

onready var explosion_resource = preload("res://Scenes/Explosion.tscn")

var explosion

var type = 'Enemy'
export var enemy_type = 'Basic'
export var can_fly = false
var vel = Vector2()
var dir = 1
var health = 1
var bob = 1
var color = Color(1,1,1,1)

func _ready():

	#Initialize bobbing
	randomize()
	bob = randf()*2 / 2

	health = 1
	if enemy_type == 'Tank':
		health = 2
		set_scale(Vector2(1.5, 1.5))
		$Sprites/Default.set_visible(false)
		$Sprites/Tank.set_visible(true)
	if enemy_type == 'Boom':
		$Sprites/Default.set_visible(false)
		$Sprites/Xplodr.set_visible(true)
	pass

func _physics_process(delta):
	if health <= 0:
		die()

	#Enemy damaged
	if $Area2D.get_overlapping_bodies().size() > 0:
		for body in $Area2D.get_overlapping_bodies():
			if body.name != 'Player':
				if body.name == 'Spikes':
					damaged()

	#Die if outside of screen
	if self.get_global_transform_with_canvas().get_origin().x < 0 or self.get_global_transform_with_canvas().get_origin().x > get_viewport_rect().size.x or self.get_global_transform_with_canvas().get_origin().y > get_viewport_rect().size.y:
		die()

	#Gravity
	if !can_fly:
		vel.y += GRAVITY

	if SPEED:
		if !can_fly:
			if $Right.get_overlapping_bodies().size() and !$Left.get_overlapping_bodies().size():
				dir = 1*(abs(SPEED)/SPEED)
			if !$Right.get_overlapping_bodies().size() and $Left.get_overlapping_bodies().size():
				dir = -1*(abs(SPEED)/SPEED)
		if $Right2.get_overlapping_bodies().size() and !$Left2.get_overlapping_bodies().size():
			dir = -1*(abs(SPEED)/SPEED)
		if !$Right2.get_overlapping_bodies().size() and $Left2.get_overlapping_bodies().size():
			dir = 1*(abs(SPEED)/SPEED)
	vel.x += SPEED*dir*.2

	move_and_slide(vel, Vector2(0, -1))

	#Spriteflip
	if dir > 0:
		for sprite in $Sprites.get_children():
			sprite.flip_h = true
	else:
		for sprite in $Sprites.get_children():
			sprite.flip_h = false

	#On floor
	if is_on_floor():
		vel.y = 0
		vel.x *= GROUND_FRICTION
	else:
		if can_fly:
			vel *= AIR_FRICTION * .8
		else:
			vel.x *= AIR_FRICTION
	#On wall
	if is_on_wall():
		vel.x = vel.x * .3 * -1
	#On ceiling
	if is_on_ceiling() and vel.y < 0:
		vel.y = 0

	#Bobbing sprite
	$Sprites.set_position(Vector2(0, sin(get_position().x/5)*2))
	if can_fly:
		$Sprites.set_position(Vector2(0, cos(bob)))
		bob += .1

	#Color flash
	get_node("Sprites").modulate = color
	if color.r > 1:
		color.r *= .8
	if color.g > 1:
		color.g *= .8
	if color.b > 1:
		color.b *= .8
	color.a = 1

func die():
	if enemy_type == 'Boom':
		explosion = explosion_resource.instance()
		explosion.set_position(get_position())
		get_parent().add_child(explosion)
	queue_free()

func damaged():
	health -= 1
	color = Color(10,1,1,1)