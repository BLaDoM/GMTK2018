extends Label

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		set_visible(true)


func _on_Area2D_body_exited(body):
	if body.name == 'Player':
		queue_free()
