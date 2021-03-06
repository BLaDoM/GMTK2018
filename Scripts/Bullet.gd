extends KinematicBody2D

const SPEED = 500

export var type = 'Bullet'

onready var explosion_resource = preload("res://Scenes/Explosion.tscn")
onready var bullet_sound_resource = preload("res://Scenes/BulletSound.tscn")
var explosion
var bullet_sound

var angle
var angle_vector

func _ready():
	get_node("../..").shake_amount = 10
	get_node("../..").controller_shake = .5
	set_rotation_degrees(angle)
	bullet_sound = bullet_sound_resource.instance()
	bullet_sound.set_position(get_position())
	get_node("../..").add_child(bullet_sound)

func _physics_process(delta):
	bullet_sound.set_position(get_position())
	move_and_slide(angle_vector*SPEED)
	for body in $Area2D.get_overlapping_bodies():
		if body and body.name != 'Player':
			if body.get_class() == 'KinematicBody2D' and body.type == 'Enemy':
				get_node("../../Player").color = Color(10,10,10,1)
				get_node("../../Player/Reload").stop()
				body.damaged()
			die()

func _on_Life_timeout():
	queue_free()

func die():
	get_node("../..").shake_amount = 50
	get_node("../..").controller_shake = 1
	explosion = explosion_resource.instance()
	explosion.set_position(get_position())
	get_parent().add_child(explosion)
	explosion.power = .3
	queue_free()