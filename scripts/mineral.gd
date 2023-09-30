extends StaticBody2D
class_name Mineral

const heat_area = preload("res://scenes/HeatArea.tscn")

export var HP: int = 1000

var depleted: bool = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if HP < 1:
		depleted = true
	

func mining():
	HP -= 1
	if HP < 1:
		call_deferred("depleted")
		return true
	
func depleted():
	var new_heat = heat_area.instance()
	new_heat.global_position = global_position
	get_parent().add_child(new_heat)
	queue_free()
