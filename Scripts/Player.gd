extends KinematicBody2D

export var SPEED = 70
export var GRAVITY = 10
export var KICKBACK = 500
export var GROUND_FRICTION = .8
export var AIR_FRICTION = .98
export var WALL_FRICTION = .6
export var MAX_HEALTH = 6
const DEAD_ZONE = .2

export var type = 'Player'

var bullet_resource = preload("res://Scenes/Bullet.tscn")
var bullet

onready var health = get_node("UI/Health")

#   Velocity for movement
var vel = Vector2()
var mouse_pos = Vector2()
#Angle of gun
var angle
#Angel but in vector form
var angle_vector = Vector2()

#Project Resolution
var res

#To flash colors
var color = Color(1,1,1,1)

var bullet_angle
var bullet_angle_vector

var player_viewport_pos = Vector2()

var level = 1
var rx_axis = 0

func _ready():
	health.value = MAX_HEALTH
	reset()

func _physics_process(delta):
	#Get current level
	level = get_node("..").level
	#Debug
	if Input.is_action_just_pressed("ui_page_up"):
		get_parent().load_level(1)
	if Input.is_action_just_pressed("ui_page_down"):
		get_parent().load_level(-1)

	#Die if outside of screen
	if self.get_global_transform_with_canvas().get_origin().x < 0 or self.get_global_transform_with_canvas().get_origin().x > get_viewport_rect().size.x or self.get_global_transform_with_canvas().get_origin().y > get_viewport_rect().size.y:
		die()

	#Movement

	#Move right
	if Input.is_action_pressed("ui_right") and vel.x < SPEED*2:
		if is_on_floor() and ($Reload.is_stopped() or $Reload.time_left < .8):
			#Ground movement speed
			vel.x += SPEED
		else:
			#Air movement speed
			vel.x += SPEED*.1
	#Move left
	if Input.is_action_pressed("ui_left") and vel.x > -SPEED*2:
		if is_on_floor() and ($Reload.is_stopped() or $Reload.time_left < .8):
			#Ground movement speed
			vel.x += -SPEED
		else:
			#Air movement speed
			vel.x += -SPEED*.1
	#Controller
	if abs(Input.get_joy_axis(0, 0)) > DEAD_ZONE and abs(vel.x) < SPEED*2:
		if is_on_floor() and ($Reload.is_stopped() or $Reload.time_left < .8):
			#Ground movement speed
			vel.x += Input.get_joy_axis(0,0)*SPEED
		else:
			#Air movement speed
			vel.x += Input.get_joy_axis(0,0)*SPEED*.1
	
	#Gravity
	vel.y += GRAVITY
	
	#Move
	move_and_slide(vel, Vector2(0, -1))
	
	#On floor
	if is_on_floor():
		vel.y = 0
		if $Reload.is_stopped() or $Reload.time_left < .8:
			vel.x *= GROUND_FRICTION
	else:
		vel.x *= AIR_FRICTION
	#On wall
	if is_on_wall():
		#Slide
		#vel.x += (abs(vel.x) / vel.x) * WALL_FRICTION
		#Bounce
		vel.x = vel.x * .3 * -1
	#On ceiling
	if is_on_ceiling() and vel.y < 0:
		vel.y = 0

	#Get mouse position relative to center of screen
	#mouse_pos = Vector2(get_viewport().get_mouse_position().x - (res.x/2) - player_viewport_pos.x, get_viewport().get_mouse_position().y - (res.y/2) - player_viewport_pos.y)

	#RotateGun
	#Check for mouse or controller
	if !abs(Input.get_joy_axis(0,2)) > DEAD_ZONE and !abs(Input.get_joy_axis(0,3)) > DEAD_ZONE:
		#Get mouse position relative to  player
		mouse_pos = get_viewport().get_mouse_position() - self.get_global_transform_with_canvas().get_origin()
		angle = atan2(mouse_pos.x, -mouse_pos.y)*(180/PI)
		angle_vector = Vector2(sin(angle*(PI/180)), cos(angle*(PI/180)))
	else:
		#Controller
		angle_vector = Vector2(Input.get_joy_axis(0,2), -Input.get_joy_axis(0,3))
		angle = atan2(angle_vector.x, angle_vector.y)*(180/PI)
	$Gun.set_rotation_degrees(angle - 90)

	#Flip sprite
	if angle < 0:
		$Gun.flip_v = true
	else:
		$Gun.flip_v = false

	#White flash
	get_node("PlayerSprite").modulate = color
	if color.r > 1:
		color.r *= .8
	if color.g > 1:
		color.g *= .8
	if color.b > 1:
		color.b *= .8
	color.a = 1

	#Collision with objects
	if $Area2D.get_overlapping_bodies().size() > 1:
		for body in $Area2D.get_overlapping_bodies():
			if body.name != 'Player':
				if body.get_class() == 'KinematicBody2D' and body.type == 'Enemy':
					damage()
				if body.name == 'Spikes':
					damage()
				"""if body.name == 'Goal':
					get_parent().next_level()"""

	#Temp sprite bobbing
	if is_on_floor():
		$PlayerSprite.set_position(Vector2(0, cos(get_position().x/10)*2))

func _input(event):
	#Debug
	"""if event.get_class() != 'InputEventMouseMotion':
		print(event.get_class())"""
	if event.is_action_pressed("ui_shoot"):
		if $Reload.is_stopped():
			$Reload.start()
			shoot()
	if event.is_action_pressed("restart"):
		die()
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func shoot():
	vel += Vector2(-angle_vector.x * KICKBACK * 1.2, angle_vector.y * KICKBACK * 1)
	if is_on_floor() and angle_vector.y * KICKBACK * 1 > 0:
		vel.y += (-angle_vector.y * KICKBACK * .8)*2
	bullet = bullet_resource.instance()
	bullet.set_position(get_position())
	bullet.angle = angle
	bullet.angle_vector = Vector2(angle_vector.x, -angle_vector.y)
	for node in get_parent().get_children():
		if node.get_class() == 'TileMap':
			node.add_child(bullet)

func _on_Reload_timeout():
	#Flash white
	color = Color(10, 10, 10, 1)

func die():
	health.value = MAX_HEALTH
	#health.set_visible(false)
	get_parent().load_level(0)

func reset():
	#Set position to PlayerSpawnPoint
	for node in get_parent().get_children():
		if node.get_class() == 'TileMap':
			set_position(node.get_node("PlayerSpawnPoint").get_position())
	vel = Vector2(0,0)

func damage():
	if $InvincibilityFrames.is_stopped():
		color = Color(10,1,1,1)
		health.value -= 1
		health.set_visible(true)
		if health.value <= 0:
			die()
		$InvincibilityFrames.start()