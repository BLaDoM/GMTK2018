extends Node

#so a nonexisten level doesn't get loaded
export var NUMBER_OF_LEVELS = 4

var enemy_resource = preload("res://Scenes/Enemy.tscn")
var enemy
var level = 1
var number_of_enemies

func _ready():
	randomize()
	pass

func _process(delta):
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
		next_level()

func next_level():
	if NUMBER_OF_LEVELS > level:
		get_node("Level" + str(level)).queue_free()
		level += 1
		add_child(load("res://Scenes/Level" + str(level) + ".tscn").instance())
		get_node("Player").reset()