extends Node

func _Play():
	get_tree().change_scene("res://Scenes/Controller.tscn")

func _Credits():
	get_tree().change_scene("res://Scenes/Credits.tscn")

func _Quit():
	get_tree().quit()