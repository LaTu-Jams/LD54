extends Area2D


var mineral_amount: int = 0

var _player = null
var receiving_minerals = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _player:
		if _player.current_temperature > 0:
			_player.current_temperature -= 10.0 * delta
			$CoolerParticle.emitting = true
			$CoolerParticle2.emitting = true
		elif not receiving_minerals:
			$CoolerParticle.emitting = false
			$CoolerParticle2.emitting = false
			$AnimationPlayer.advance(0)
			$AnimationPlayer.play("RESET")
	else: 
		$CoolerParticle.emitting = false
		$CoolerParticle2.emitting = false

func _on_HomeDepot_body_entered(body):
	if body.is_in_group("player"):
		_player = body
		if _player._mineral_amount > 0:
			var amount = _player._mineral_amount
			get_tree().current_scene.level.add_minerals(_player._mineral_amount)
			_player._mineral_amount = 0
			_receive_minerals(amount)


func _on_HomeDepot_body_exited(body):
	if body.is_in_group("player"):
		_player = null
	pass # Replace with function body.
	


func _receive_minerals(loops):
	receiving_minerals = true
	# 0.6 is the animation track time
	var run_time = 0.6 * loops
	$AnimationPlayer.advance(0)
	$AnimationPlayer.play("mineral")
	yield(get_tree().create_timer(run_time), "timeout")
	receiving_minerals = false
	$AnimationPlayer.advance(0)
	$AnimationPlayer.play("RESET")
