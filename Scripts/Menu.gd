extends Node

var i = 3

func _ready():
	$Fade.set_visible(true)
	$Fade.set_modulate(Color(0,0,0,0))

func _process(delta):
	if i < 2:
		$Fade.set_modulate(Color(0,0,0,i))
	$MenuMusic.volume_db = 0-i/20
	i += .01
	if i > 1 and i < 2:
		get_tree().change_scene("res://Scenes/Controller.tscn")

func _Play():
	i = 0

func _Credits():
	get_tree().change_scene("res://Scenes/Credits.tscn")

func _Quit():
	get_tree().quit()
