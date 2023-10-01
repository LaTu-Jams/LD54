extends KinematicBody2D
class_name Enemy

onready var agent := $NavigationAgent2D

signal reached_destination

export var speed = 50
var waiting := false


func _physics_process(delta):
	if agent.is_navigation_finished() and not waiting:
		waiting = true
		yield(get_tree().create_timer(1), "timeout")
		emit_signal("reached_destination", self)
	elif not agent.is_navigation_finished():
		var direction = global_position.direction_to(agent.get_next_location())
		var velocity = direction * speed
		move_and_slide(velocity)


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.die("Monster ate you")


