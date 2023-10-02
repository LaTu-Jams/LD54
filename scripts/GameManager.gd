extends Node2D
class_name GameManager

onready var player = $Player
onready var level
onready var UI := $UI
onready var particles = $Particles
var current_level: int = 1

var game_started: bool = false

var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	level = load("res://scenes/levels/Level_"+str(current_level)+".tscn").instance()
	add_child(level)
	rng = RandomNumberGenerator.new()
	rng.randomize()
	UI.initialize()
	get_tree().paused = true

func _input(event):
	if (UI.get_node("Menu").visible == false and UI.get_node("VictoryScreen").visible == false) and (event.is_action_pressed("Mine") or event.is_action_pressed("move_forward") or event.is_action_pressed("move_backward") or event.is_action_pressed("turn_left") or event.is_action_pressed("turn_right")):
		get_tree().paused = false
		UI.get_node("StartLayout").visible = false
		game_started = true
	if event.is_action_pressed("pause_game") and game_started:
		UI.get_node("Menu").visible = true
		get_tree().paused = true
	if Input.is_action_pressed("interact") and level.minerals_gathered >= level.mineral_goal:
		
		win_game()

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
	var restarted_level = load("res://scenes/levels/Level_"+str(current_level)+".tscn").instance()
	add_child(restarted_level)
	level = restarted_level
	UI.get_node("DefeatScreen").visible = false
	UI.initialize()
	

func next_level():
	current_level += 1
	level.queue_free()
	var next_lvl = load("res://scenes/levels/Level_"+str(current_level)+".tscn").instance()
	add_child(next_lvl)
	level = next_lvl
	UI.get_node("VictoryScreen").visible = false
	UI.get_node("StartLayout").visible = true
	UI.initialize()


func win_game():
	get_tree().paused = true
	UI.get_node("VictoryScreen").visible = true
	
