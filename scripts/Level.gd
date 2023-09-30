extends Node2D

const EMPTY_TILE = -1
const GROUND_TILE = 0
const FLOOR_TILE = 1

onready var floor_layer = $Floor
onready var ground_layer = $Ground


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(2,12):
		for y in range(2,12):
			_remove_ground(Vector2(x,y))
			yield(get_tree().create_timer(0.1), "timeout")

func _remove_ground(pos : Vector2):
	var tile = ground_layer.get_cellv(pos)
	if tile > -1:
		ground_layer.set_cellv(pos, EMPTY_TILE)
		ground_layer.update_bitmask_area(pos)
		ground_layer.update_dirty_quadrants()
		floor_layer.set_cellv(pos, FLOOR_TILE)
		floor_layer.update_bitmask_area(pos)
		floor_layer.update_dirty_quadrants()
	
