extends Node

#so a nonexisten level doesn't get loaded
export var NUMBER_OF_LEVELS = 5

var enemy_resource = preload("res://Scenes/Enemy.tscn")

var level1 = preload("res://Scenes/Levels/Level1.tscn")
var level2 = preload("res://Scenes/Levels/Level2.tscn")
var level3 = preload("res://Scenes/Levels/Level3.tscn")
var level4 = preload("res://Scenes/Levels/Level4.tscn")
var level5 = preload("res://Scenes/Levels/Level5.tscn")
var level6 = preload("res://Scenes/Levels/Level6.tscn")

var enemy
var level = 1
var number_of_enemies
var shake_amount = 0
var controller_shake = 0
var rumble = 0

func _ready():
	load_level(0)
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
		level_win()

	#Very basic screen shake
	$Camera2D.set_offset(Vector2( rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount ))
	shake_amount *= .6
	#Controller rumble
	if rumble <= controller_shake:
		Input.start_joy_vibration(0,controller_shake,controller_shake,controller_shake*.3)
		rumble = controller_shake
	controller_shake = 0
	rumble -= .1

func level_win():
	$Win.play()
	while $Win.get_playback_position() < 1.5:
		pass
	load_level(1)

#Loads the level plus number
func load_level(number, force_load=0):
	remove_child(get_node("Level" + str(level)))
	if force_load:
		level = force_load
	if NUMBER_OF_LEVELS > level:
		level += number
	else:
		level = 1
	print(level)
	if level == 1:
		add_child(level1.instance())
	if level == 2:
		add_child(level2.instance())
	if level == 3:
		add_child(level3.instance())
	if level == 4:
		add_child(level4.instance())
	if level == 5:
		add_child(level5.instance())
	if level == 6:
		add_child(level6.instance())
	
	get_node("Player").reset()