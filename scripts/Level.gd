extends Node2D
class_name Level

const EMPTY_TILE = -1
const GROUND_TILE = 0
const FLOOR_TILE = 1

onready var mineral_prefab = preload("res://scenes/Mineral.tscn")
onready var enemy_prefab = preload("res://scenes/Enemy.tscn")

onready var floor_layer = $EnemyNavigation/Floor
onready var ground_layer = $EnemyNavigation/Ground
onready var enemy_spawns = $EnemySpawns
onready var mineral_spawns = $MineralSpawns

export var minerals_in_level = 3
export var mineral_goal = 1
export var enemies_in_level  = 0

var minerals_gathered = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(2,4):
		for y in range(2,4):
			if _remove_ground(Vector2(x,y)):
				yield(get_tree().create_timer(0.05), "timeout")
	
	_spawn_minerals()
	_spawn_enemies()
	$EnemyNavigation.initialize(floor_layer)

func _remove_ground(pos : Vector2):
	var tile = ground_layer.get_cellv(pos)
	if tile > -1:
		ground_layer.set_cellv(pos, EMPTY_TILE)
		ground_layer.update_bitmask_area(pos)
		floor_layer.set_cellv(pos, FLOOR_TILE)
		floor_layer.update_bitmask_area(pos)
		return true
	return false


func _spawn_minerals():
	var spawns_taken = []
	for i in minerals_in_level:
		var mineral = mineral_prefab.instance()
		$Minerals.add_child(mineral)
		
		var found_pos = false
		var max_attempts = 100
		var attempts = 0
		while not found_pos and attempts < 100:
			var pos = get_parent().rng.randi_range(0, mineral_spawns.get_child_count()-1)
			pos = mineral_spawns.get_child(pos).global_position
			# Center to tile
			pos = floor_layer.world_to_map(pos)
			pos = floor_layer.map_to_world(pos) + Vector2.ONE * 16
			if spawns_taken.find_last(pos) == -1:
				print("Spawning mineral at %s" % pos)
				spawns_taken.append(pos)
				mineral.global_position = pos
				found_pos = true
			attempts += 1


func _spawn_enemies():
	var spawns_taken = []
	for i in enemies_in_level:
		var enemy = enemy_prefab.instance()
		$EnemyNavigation/Enemies.add_child(enemy)
		
		var found_pos = false
		var max_attempts = 100
		var attempts = 0
		while not found_pos and attempts < 100:
			var pos = get_parent().rng.randi_range(0, enemy_spawns.get_child_count()-1)
			pos = enemy_spawns.get_child(pos).global_position
			# Center to tile
			pos = floor_layer.world_to_map(pos)
			pos = floor_layer.map_to_world(pos) + Vector2.ONE * 16
			
			if spawns_taken.find_last(pos) == -1:
				print("Spawning enemies at %s" % pos)
				spawns_taken.append(pos)
				enemy.global_position = pos
				found_pos = true
			attempts += 1


func add_minerals(amount: int):
	minerals_gathered += amount
	if minerals_gathered >= mineral_goal:
		get_tree().current_scene.next_level()
