extends Control

var fade = 1
var is_fade = false

func _ready():
	$Sprite.set_modulate(Color(1,1,1,1))
	pass

func _process(delta):
	$Sprite.set_modulate(Color(1,1,1, 1-fade))
	$AudioStreamPlayer.volume_db = (fade - 1)*10
	if is_fade == true:
		fade -= .1
		if fade < .3:
			get_tree().change_scene("res://Scenes/Controller.tscn")


func _on_Button_pressed():
	is_fade == true


func _on_Button2_pressed():
	print("Button2pressed")