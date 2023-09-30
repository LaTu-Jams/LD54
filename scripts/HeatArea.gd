extends Area2D

var _player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _player:
		_player.current_temperature += 1 * delta
	


func _on_HeatArea_body_entered(body):
	#print("something entered")
	if body is Player:
		#print("player entered")
		_player = body



func _on_HeatArea_body_exited(body):
	#print("something exited")
	if body is Player:
		#print("player exited")
		_player = null
