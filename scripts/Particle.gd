extends CPUParticles2D
class_name Particle

export var life_time = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(life_time), "timeout")
	call_deferred("queue_free")
