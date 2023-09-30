extends Node2D
class_name EnemyNavigation

var nav_map
var tile_map
var rng

func _ready():
	rng = RandomNumberGenerator.new()

func initialize(map: TileMap):
	tile_map = map
	nav_map = Navigation2DServer.map_create()
	Navigation2DServer.region_set_navigation_layers(nav_map, 1)
	for e in $Enemies.get_children():
		e.connect("reached_destination", self, "give_new_path")
		get_nav_path(e)


func get_nav_path(object:Enemy):
	var origin = object.global_position
	var tiles = tile_map.get_used_cells_by_id(get_parent().FLOOR_TILE)
	var tile = tiles[rng.randi_range(0, tiles.size()-1)]
	var destination = tile_map.map_to_world(tile)
	
	
	object.agent.set_target_location(destination)
	object.waiting = false


func give_new_path(e: Enemy):
	get_nav_path(e)
