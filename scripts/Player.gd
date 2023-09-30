extends KinematicBody2D

onready var ray_cast_2d = $RayCast2D

export var speed: int = 100
export var max_temperature: int = 100
export var in_control: bool = true
export var turning_time: float = 0.8

var current_temperature: int = 0
var _mineral_amount: int = 0
var _facing_direction: String = "down"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = _movement()
	
	velocity = move_and_slide(velocity)
	


func _movement():
	var velocity = Vector2(0,0)
	if Input.is_action_pressed("move_forward") and in_control:
		if _facing_direction == "down":
			velocity = Vector2(0, speed)
		if _facing_direction == "up":
			velocity = Vector2(0, -speed)
		if _facing_direction == "left":
			velocity = Vector2(-speed, 0)
		if _facing_direction == "right":
			velocity = Vector2(speed, 0)
	
	if Input.is_action_pressed("move_backward") and in_control:
		if _facing_direction == "down":
			velocity = Vector2(0, -speed/2)
		if _facing_direction == "up":
			velocity = Vector2(0, speed/2)
		if _facing_direction == "left":
			velocity = Vector2(speed/2, 0)
		if _facing_direction == "right":
			velocity = Vector2(-speed/2, 0)

	if Input.is_action_just_pressed("turn_left") and in_control:
		var tween = get_tree().create_tween()
		in_control = false
		tween.tween_property(self, "rotation_degrees", rotation_degrees - 90, turning_time)
#		tween.start()
		if _facing_direction == "down":
			_facing_direction = "right"
		elif _facing_direction == "right":
			_facing_direction = "up"
		elif _facing_direction == "up":
			_facing_direction = "left"
		elif _facing_direction == "left":
			_facing_direction = "down"
		tween.tween_property(self, "in_control", true, 0)
	if Input.is_action_just_pressed("turn_right") and in_control:
		var tween = get_tree().create_tween()
		in_control = false
		tween.tween_property(self, "rotation_degrees", rotation_degrees + 90, turning_time)
		#rotate(PI/2)
		if _facing_direction == "down":
			_facing_direction = "left"
		elif _facing_direction == "left":
			_facing_direction = "up"
		elif _facing_direction == "up":
			_facing_direction = "right"
		elif _facing_direction == "right":
			_facing_direction = "down"
		tween.tween_property(self, "in_control", true, 0)
	return velocity
