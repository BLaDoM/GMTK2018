extends Node

var score = 0

func _ready():
	updateScore()

func addScore(amount):
	score += amount
	updateScore()

func updateScore():
	find_node("ScoreLabel").text = "SCORE: %010d" % score