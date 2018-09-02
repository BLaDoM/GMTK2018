extends Node

#so a nonexisten level doesn't get loaded
export var NUMBER_OF_LEVELS = 4

var enemy_resource = preload("res://Scenes/Enemy.tscn")
var enemy
var level = 0
var number_of_enemies
var shake_amount = 0

func _ready():
	load_level(1)
	randomize()

func _process(delta):
	if Input.is_action_pressed("key_exit"):
      get_tree().quit()
	#Debug
	"""if randi()%100 == 1:
		enemy = enemy_resource.instance()
		enemy.set_position(Vector2((randf()*1000)-500, (randf()*1000)-500))
		get_node("Level1").add_child(enemy)"""
	#End level if no ememies
	number_of_enemies = 0
	for node in get_children():
		if node.get_class() == 'TileMap':
			for tilenode in node.get_children():
				if tilenode.get_class() == 'KinematicBody2D' and tilenode.type == 'Enemy':
					number_of_enemies += 1
	if number_of_enemies == 0:
		load_level(1)

	#Very basic screen shake
	$Camera2D.set_offset(Vector2( rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount ))
	shake_amount *= .6

#Loads the level plus number
func load_level(number):
	if NUMBER_OF_LEVELS > level:
		remove_child(get_node("Level" + str(level)))
		level += number
		add_child(load("res://Scenes/Levels/Level" + str(level) + ".tscn").instance())
		get_node("Player").reset()