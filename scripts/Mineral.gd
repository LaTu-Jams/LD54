extends StaticBody2D
class_name Mineral

const heat_area = preload("res://scenes/HeatArea.tscn")

export var HP: float = 6
var HP_max

var depleted: bool = false
var glimmer_time


func _ready():
	HP_max = HP
	
	while not is_instance_valid(get_tree().current_scene.rng):
		yield(get_tree(), "idle_frame")
	var time_mod = get_tree().current_scene.rng.randi_range(-5,15)
	
	glimmer_time = $Glimmer/GlimmerTimer.wait_time + time_mod
	$Glimmer/GlimmerTimer.wait_time = glimmer_time
	$Glimmer/GlimmerTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if HP < 1:
		depleted = true
		$Sprite.frame = 3
	elif HP/HP_max <= 0.33 and $Sprite.frame != 2:
		$Sprite.frame = 2
	elif HP/HP_max > 0.33 and HP/HP_max <= 0.66 and $Sprite.frame != 1:
		$Sprite.frame = 1
	elif HP/HP_max > 0.66 and $Sprite.frame != 0:
		$Sprite.frame = 0

func mining():
	HP -= 1 * get_process_delta_time()
	if HP < 1:
		call_deferred("depleted")
		return true
	
		
	
func depleted():
	var new_heat = heat_area.instance()
	new_heat.global_position = global_position
	get_parent().add_child(new_heat)
	$CollisionShape2D.disabled = true
	remove_from_group("mineral")
	# queue_free()


func _on_glimmer():
	print("%s glimmering" % self)
	$Glimmer/GlimmerAnimator.play("glimmer")
