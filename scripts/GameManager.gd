extends Node2D
class_name GameManager

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

func _input(event):
	if UI.get_node("Menu").visible == false and (event.is_action_pressed("Mine") or event.is_action_pressed("move_forward") or event.is_action_pressed("move_backward") or event.is_action_pressed("turn_left") or event.is_action_pressed("turn_right")):
		get_tree().paused = false
		UI.get_node("StartLayout").visible = false

func remove_ground(position):
	print(level.get_node("EnemyNavigation").get_node("Ground").world_to_map(position))
	var ground_coords = level.get_node("EnemyNavigation").get_node("Ground").world_to_map(position)
	if ground_coords:
		#print(ground_coords)
		level._remove_ground(ground_coords)


func emit_mining_particles(pos : Vector2):
	particles.spawn_mining_particle(pos)


func emit_trail_particles(pos : Vector2, rotation):
	particles.spawn_trail_particle(pos, rotation)


func lose_game(message):
	UI.get_node("DefeatScreen").get_node("Label").text = message
	UI.get_node("DefeatScreen").visible = true
	#get_tree().reload_current_scene()

func restart_level():
	level.queue_free()
	var restarted_level = load("res://scenes/Level"+".tscn").instance()
	add_child(restarted_level)
	level = restarted_level
	UI.get_node("DefeatScreen").visible = false
	

func next_level():
	get_tree().reload_current_scene()


func win_game():
	get_tree().reload_current_scene()
