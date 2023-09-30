extends Node2D
class_name GameManager

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = $Player
onready var level  : Level = $Level
onready var UI := $UI

var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	UI.initialize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
