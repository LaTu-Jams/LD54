class_name HeatArea
extends Area2D

var current_player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_player:
		current_player.current_temperature += 1 * delta
	


func _on_HeatArea_body_entered(body):
	#print("something entered")
	if body.is_in_group("player"):
		#print("player entered")
		current_player = body
	return



func _on_HeatArea_body_exited(body):
	#print("something exited")
	if body.is_in_group("player"):
		#print("player exited")
		current_player = null
	return
