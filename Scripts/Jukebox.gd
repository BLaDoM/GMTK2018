extends Node

var audioBuses = {} # Dictionary containing each bus and it's current target volume
const volumes = [[0.0, -100.0, -100.0, -100.0], [0.0, 0.0, -100.0, -100.0], [0.0, 0.0, 0.0, -100.0], [0.0, 0.0, 0.0, 0.0]]
var t = 0.0

func _ready():
	audioBuses = {
		get_node("AudioStreamPlayer"):0.0,
		get_node("AudioStreamPlayer2"):0.0,
		get_node("AudioStreamPlayer3"):0.0,
		get_node("AudioStreamPlayer4"):0.0}

func _process(delta):
	for i in range(len(audioBuses)):
		audioBuses.keys()[i].volume_db = lerp(audioBuses.keys()[i].volume_db, audioBuses.values()[i], delta * 0.1)

func updateVolumes(healthPercentage):
	var i = ceil(float(healthPercentage) / 4) * 4 - 1
	audioBuses = {
		get_node("AudioStreamPlayer"):volumes[i][0],
		get_node("AudioStreamPlayer2"):volumes[i][1],
		get_node("AudioStreamPlayer3"):volumes[i][2],
		get_node("AudioStreamPlayer4"):volumes[i][3]}