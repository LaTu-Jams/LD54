extends CanvasLayer
class_name UIManager

onready var heat_meter := $HeatMeter
onready var mineral_meter := $MineralMeter
var overheat_alarm_on = false


func initialize():
	heat_meter.max_value = get_parent().get_child(2).get_node("Player").max_temperature
	heat_meter.value = get_parent().get_child(2).get_node("Player").current_temperature
	mineral_meter.max_value = get_parent().get_child(2).mineral_goal
	mineral_meter.value = get_parent().get_child(2).minerals_gathered
	print(mineral_meter.max_value)
	overheat_alarm_on = false

func _process(delta):
	#print((get_parent().get_node("Level")))
	if get_parent().get_child(2):
		#print(get_parent().get_child(3))
		#print(is_instance_valid(get_parent().get_child(3).get_node("Player")))
		if is_instance_valid(get_parent().get_child(2).get_node("Player")):
			heat_meter.value = get_parent().get_child(2).get_node("Player").current_temperature
			if heat_meter.value/heat_meter.max_value >= 0.75 and not overheat_alarm_on:
				_warn_overheating()
	
	mineral_meter.value = get_parent().get_child(2).minerals_gathered

	if mineral_meter.value >= get_parent().get_child(2).mineral_goal:
		$NextLevel.visible = true
	elif $NextLevel.visible:
		$NextLevel.visible = false


func _warn_overheating():
	overheat_alarm_on = true
	while heat_meter.value/heat_meter.max_value >= 0.75:
		SoundManager.sound("overheat_warning", 3)
		var tween = get_tree().create_tween()
		tween.tween_property(heat_meter, "modulate", Color.orangered, 0.5)
		tween.tween_property(heat_meter, "modulate", Color.white, 0.5)
		yield(tween, "finished")
	overheat_alarm_on = false
