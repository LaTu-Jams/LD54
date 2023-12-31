extends KinematicBody2D
class_name Player

onready var ray_cast_2d = $RayCast2D
onready var animation_player : AnimationPlayer = $AnimationPlayer

export var speed: float = 100.0
export var max_temperature: float = 100.0
export var in_control: bool = true
export var turning_time: float = 0.5
export var drill_db = -5


var current_temperature: float = 0.0
var _mineral_amount: int = 0
var _facing_direction: String = "down"
var is_mining = false
var mining_ground := 0.0
var has_exploded = false

func _ready():
	SoundManager.connect("volume_changed", self, "_on_volume_change")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = _movement()
	$TrailParticle.emitting = velocity != Vector2.ZERO
	
#	if velocity != Vector2.ZERO:
#		get_tree().current_scene.emit_trail_particles(global_position, rotation_degrees)
	if velocity == Vector2(0,0) and !is_mining and in_control and current_temperature > 0:
		current_temperature -= 1.0 * delta
	if !is_mining:
		if velocity != Vector2.ZERO and animation_player.current_animation != "move":
			animation_player.advance(0)
			animation_player.play("move")
		elif velocity == Vector2.ZERO and animation_player.current_animation != "idle":
			animation_player.advance(0)
			animation_player.play("idle")
	if Input.is_action_pressed("Mine") and in_control:
		is_mining = _mine()
		if is_mining:
			if animation_player.current_animation != "drill":
				animation_player.advance(0)
				animation_player.play("drill")
			current_temperature += 5 * delta
#			_emit_mining_particle()
			$MiningParticle.emitting = true
	else: #Input.is_action_just_released("Mine") and in_control:
		is_mining = false
		
	if is_mining and !$DrillSound.playing:
		$DrillSound.playing = true
	elif !is_mining and $DrillSound.playing:
		$DrillSound.playing = false
		
	if current_temperature >= max_temperature and not has_exploded:
		die("Overheated")
	
	$MiningParticle.emitting = is_mining
	velocity = move_and_slide(velocity)
	
func die(message):
	in_control = false
	$RotarySound.playing = false
	$DrillSound.playing = false
	get_tree().current_scene.lose_game(message)
#	visible = false
	#call_deferred("queue_free")
	
	
func _mine():
	#print("mining " + str(ray_cast_2d.get_collider()))
	#yield(get_tree().create_timer(1),"timeout")
	if ray_cast_2d.get_collider():
		if ray_cast_2d.get_collision_point().x > 0 and ray_cast_2d.get_collision_point().x < 1024 and ray_cast_2d.get_collision_point().y > 0 and ray_cast_2d.get_collision_point().y < 600:
			
		#print(ray_cast_2d.get_collider())
			if ray_cast_2d.get_collider().is_in_group("mineral"):
				#print("mining mineral")
				#current_temperature += 0.5
				if ray_cast_2d.get_collider().mining():
					_mineral_amount += 1
				return true
			elif ray_cast_2d.get_collider().is_in_group("ground"):
	#			yield(get_tree().create_timer(0.5),"timeout")
				#print(mining_ground)
				mining_ground += get_process_delta_time()
				current_temperature += 2.5 * get_process_delta_time()
				if mining_ground >= 1:
					var direction = self.global_position.direction_to(ray_cast_2d.get_collision_point())
					get_tree().current_scene.remove_ground(ray_cast_2d.get_collision_point()+direction*3)
					mining_ground = 0
				return true
			
	return false

func _movement():
	var velocity = Vector2(0,0)
	#var turning = false
	if Input.is_action_pressed("move_forward") and in_control and !Input.is_action_pressed("move_backward"):
		if !$RotarySound.playing:
			var tween = get_tree().create_tween()
			$RotarySound.playing = true
			tween.tween_property($RotarySound, "pitch_scale", 1.0, 0.1)
		elif $RotarySound.playing and $RotarySound.pitch_scale != 1:
			var tween = get_tree().create_tween()
			tween.tween_property($RotarySound, "pitch_scale", 1.0, 0.15)
			
		if _facing_direction == "down":
			velocity = Vector2(0, speed)
		if _facing_direction == "up":
			velocity = Vector2(0, -speed)
		if _facing_direction == "left":
			velocity = Vector2(-speed, 0)
		if _facing_direction == "right":
			velocity = Vector2(speed, 0)
	
	if Input.is_action_pressed("move_backward") and in_control:
		if !$RotarySound.playing:
			var tween = get_tree().create_tween()
			$RotarySound.playing = true
			tween.tween_property($RotarySound, "pitch_scale", 0.5, 0.1)
		elif $RotarySound.playing and $RotarySound.pitch_scale != 0.5:
			var tween = get_tree().create_tween()
			tween.tween_property($RotarySound, "pitch_scale", 0.5, 0.15)
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
		#turning = true
		in_control = false
		
		
		var sound_tween = get_tree().create_tween()
		$RotarySound.playing = true
		sound_tween.tween_property($RotarySound, "pitch_scale", 1.1, 0.2)
		
		
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
		#tween.tween_property(self, "turning", false, 0)
		mining_ground = 0
	if Input.is_action_just_pressed("turn_right") and in_control:
		#turning = true
		var tween = get_tree().create_tween()
		in_control = false
		
		
		var sound_tween = get_tree().create_tween()
		$RotarySound.playing = true
		sound_tween.tween_property($RotarySound, "pitch_scale", 1.1, 0.2)
		
		
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
		#tween.tween_property(self, "turning", false, 0)
		mining_ground = 0
		
	if velocity == Vector2(0,0) and in_control:
		#print("rotary sound down")
		var tween = get_tree().create_tween()
		tween.tween_property($RotarySound, "pitch_scale", 0.3, 0.15)
		#tween.tween_property($RotarySound, "playing", false, 0)
		#$RotarySound.playing = false
		#$RotarySound.pitch_scale = 0.3
	return velocity


func _emit_mining_particle():
	var dir = Vector2.ZERO
	if _facing_direction == "left":
		dir = Vector2.LEFT
	elif _facing_direction == "right":
		dir = Vector2.RIGHT
	elif _facing_direction == "up":
		dir = Vector2.UP
	elif _facing_direction == "down":
		dir = Vector2.DOWN
	
	get_tree().current_scene.emit_mining_particles(global_position + dir * 20)


func _on_volume_change(volume):
	$RotarySound.volume_db = volume
	$DrillSound.volume_db = volume + drill_db


func explode():
	if has_exploded:
		return
	has_exploded = true
	$Explosion.emitting = true
	$Shrapnel.emitting = true
	SoundManager.sound("explosion")
	yield(get_tree().create_timer(0.5), "timeout")
	$Sprite.modulate = Color(0.2, 0.2, 0.2, 0.4)
	$Smoke.emitting = true
