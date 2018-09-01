extends KinematicBody2D

const SPEED = 500

var angle
var angle_vector

func _ready():
	set_rotation_degrees(angle)

func _physics_process(delta):
	move_and_slide(angle_vector*SPEED)
	for body in $Area2D.get_overlapping_bodies():
		if body and body.name != 'Player':
			if body.get_class() == 'KinematicBody2D' and body.type == 'Enemy':
				get_node("../../Player").color = Color(10,10,10,1)
				get_node("../../Player/Reload").stop()
				body.queue_free()
			queue_free()

func _on_Life_timeout():
	queue_free()