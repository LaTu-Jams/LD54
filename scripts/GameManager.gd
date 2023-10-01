extends Node2D
class_name GameManager

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = $Player
onready var level : Level = $Level
onready var UI := $UI
onready var particles = $Particles

var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	UI.initialize()
	get_tree().paused = true
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("Mine") or event.is_action_pressed("move_forward") or event.is_action_pressed("move_backward") or event.is_action_pressed("turn_left") or event.is_action_pressed("turn_right"):
		get_tree().paused = false
		UI.get_node("StartLayout").visible = false

func remove_ground(position):
	var ground_coords = level.get_node("EnemyNavigation").get_node("Ground").world_to_map(position)
	if ground_coords:
		#print(ground_coords)
		level._remove_ground(ground_coords)


func emit_mining_particles(pos : Vector2):
	particles.spawn_mining_particle(pos)


func emit_trail_particles(pos : Vector2, rotation):
	particles.spawn_trail_particle(pos, rotation)


func lose_game():
	get_tree().reload_current_scene()


func next_level():
	get_tree().reload_current_scene()


func win_game():
	get_tree().reload_current_scene()
