extends KinematicBody2D
class_name Enemy

onready var agent := $NavigationAgent2D
onready var animation_player := $AnimationPlayer
onready var trail_particle := $TrailParticle
signal reached_destination

export var speed = 50
var waiting := false
var rotating_time = 0.5


func _physics_process(delta):
	if agent.is_navigation_finished() and not waiting:
		waiting = true
#		trail_particle.emitting = false
		animation_player.advance(0)
		animation_player.play("idle")
		$TrailParticle.emitting = false
		$TrailParticle2.emitting = false
		$TrailParticle3.emitting = false
		yield(get_tree().create_timer(2), "timeout")
		emit_signal("reached_destination", self)
	elif not agent.is_navigation_finished():
		
		if animation_player.current_animation != "move":
			animation_player.advance(0)
			animation_player.play("move")
			
		
		var direction = global_position.direction_to(agent.get_next_location())
		var rotation := 0.0
		# LEFT
		if direction.x < 0 and abs(direction.x) > abs(direction.y):
			rotation = 90
		# RIGHT
		elif direction.x > 0 and abs(direction.x) > abs(direction.y):
			rotation = -90
		# UP
		elif direction.y < 0 and abs(direction.y) > abs(direction.x):
			rotation = 180
		# DOWN
		elif direction.y > 0 and abs(direction.y) > abs(direction.x):
			rotation = 0
			
		if rotation_degrees != rotation:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation_degrees", rotation, rotating_time)
#		get_tree().current_scene.emit_trail_particles(global_position, rotation_degrees)
		$TrailParticle.emitting = true
		$TrailParticle2.emitting = true
		$TrailParticle3.emitting = true
		var velocity = direction * speed
		move_and_slide(velocity)


func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().current_scene.lose_game()
		body.call_deferred("queue_free")


