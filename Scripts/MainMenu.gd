extends Control

var fade = 1
var is_fade = false

func _ready():
	$Sprite.set_modulate(Color(0,0,0,1))
	pass

func _process(delta):
	$Sprite.set_modulate(Color(0,0,0, 1-fade))
	$AudioStreamPlayer.volume_db = (fade - 1)*10
	print(fade,is_fade)
	if is_fade == true:
		fade -= .01
		if fade < .01:
			get_tree().change_scene("res://Scenes/Controller.tscn")


func _on_Button_pressed():
	is_fade = true


func _on_Button2_pressed():
	print("Button2pressed")