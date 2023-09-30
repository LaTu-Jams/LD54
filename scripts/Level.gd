extends Node2D
class_name Level

const EMPTY_TILE = -1
const GROUND_TILE = 0
const FLOOR_TILE = 1

onready var floor_layer = $EnemyNavigation/Floor
onready var ground_layer = $EnemyNavigation/Ground


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(2,4):
		for y in range(2,4):
			if _remove_ground(Vector2(x,y)):
				yield(get_tree().create_timer(0.05), "timeout")
			
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
	
