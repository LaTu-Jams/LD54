extends Area2D
class_name HeatArea

export var heating_amount = 5
var current_player


func _ready():
	$SmokeParticle.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_player:
		current_player.current_temperature += heating_amount * delta


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


