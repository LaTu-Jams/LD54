extends Area2D


var mineral_amount: int = 0

var _player = null
var receiving_minerals = false
export var cooling_sound = preload("res://sfx/cooler.ogg")
export var mineral_vol_mod = 6
export var cooler_vol_mod = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.connect("volume_changed", self, "_on_volume_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _player:
		if _player.current_temperature > 0:
			if !$CoolerSound.playing:
				$CoolerSound.play()
			_player.current_temperature -= 15.0 * delta
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
			$MineralExtract.play()
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
	

func _on_volume_changed(volume):
	$MineralExtract.volume_db = volume + mineral_vol_mod
	$CoolerSound.volume_db = volume + cooler_vol_mod
