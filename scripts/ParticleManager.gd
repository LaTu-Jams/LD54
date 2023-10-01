extends Node2D
class_name ParticleManager

onready var mining_particles = preload("res://scenes/MiningParticle.tscn")
onready var trail_particles = preload("res://scenes/TrailParticle.tscn")

export var particle_cooldown = 0.1
var current_cooldown = 0.0
var on_cooldown = false


func spawn_mining_particle(pos : Vector2):	
	var instance = mining_particles.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(instance)
	instance.global_position = pos
	instance.emitting = true


func spawn_trail_particle(pos : Vector2, rotation := 0.0):
	var instance = trail_particles.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(instance)
	instance.global_position = pos
	instance.rotation_degrees = rotation
	instance.emitting = true
