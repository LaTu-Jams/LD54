extends Node2D


var _radar_timer: float = 2
var minerals = []
var closest = Vector2(10000, 10000)
var target
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.visible = false
	$Sprite2.visible = false
	minerals = get_tree().get_nodes_in_group("mineral")
	target = _find_mineral()
	self.rotation = self.global_position.direction_to(target).angle()
	for m in minerals:
		if self.global_position.distance_to(closest) > self.global_position.distance_to(m.global_position):
			closest = m.global_position
	player = get_tree().current_scene.get_node("Player")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
	 global_position = player.global_position
	_radar_timer += delta
	self.rotation = self.global_position.direction_to(target).angle()
	if _radar_timer >= 3 and !$AnimationPlayer.is_playing():
		target = _find_mineral()
		$Sprite.visible = true
		$Sprite2.visible = true
		_radar_timer = 0
		$AnimationPlayer.play("radar")
	if _radar_timer > 1.5:
		$AnimationPlayer.stop()

func _find_mineral():
	minerals = get_tree().get_nodes_in_group("mineral")
	for m in minerals:
		if self.global_position.distance_to(closest) > self.global_position.distance_to(m.global_position):
			closest = m.global_position
	return closest
	
