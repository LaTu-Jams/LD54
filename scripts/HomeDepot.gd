extends Area2D


var mineral_amount: int = 0

var _player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _player:
		if _player.current_temperature > 0:
			_player.current_temperature -= 10.0 * delta
	


func _on_HomeDepot_body_entered(body):
	if body.is_in_group("player"):
		_player = body
		get_tree().current_scene.level.add_minerals(body._mineral_amount)
		body._mineral_amount = 0


func _on_HomeDepot_body_exited(body):
	if body.is_in_group("player"):
		_player = null
	pass # Replace with function body.
