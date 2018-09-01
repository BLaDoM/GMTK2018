extends Node2D

onready var body = get_node("Path2D/PathFollow2D")
export var speed = 100

func _ready():
	get_node("Path2D/PathFollow2D/StaticBody2D/CollisionPolygon2D").polygon = get_node("Path2D/PathFollow2D/Body").polygon

func _process(delta):
	body.offset += delta * speed