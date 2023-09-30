extends Node2D
class_name GameManager

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = $Player
onready var level : Level = $Level
onready var UI := $UI

var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	UI.initialize()
	pass # Replace with function body.

func remove_ground(position):
	var ground_coords = level.get_node("EnemyNavigation").get_node("Ground").world_to_map(position)
	if ground_coords:
		#print(ground_coords)
		level._remove_ground(ground_coords)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


