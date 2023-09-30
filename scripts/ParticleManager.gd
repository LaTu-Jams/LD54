extends Node2D
class_name ParticleManager

onready var mining_particles = preload("res://scenes/MiningParticle.tscn")


func spawn_mining_particle(pos : Vector2):
	var instance = mining_particles.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(instance)
	instance.global_position = pos
	instance.emitting = true
