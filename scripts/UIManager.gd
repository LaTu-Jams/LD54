extends CanvasLayer
class_name UIManager

onready var heat_meter := $HeatMeter
onready var mineral_meter := $MineralMeter

func initialize():
	heat_meter.max_value = get_parent().get_child(3).get_node("Player").max_temperature
	heat_meter.value = get_parent().get_child(3).get_node("Player").current_temperature
	mineral_meter.max_value = get_parent().get_child(3).minerals_in_level
	mineral_meter.value = get_parent().get_child(3).minerals_gathered


func _process(delta):
	#print((get_parent().get_node("Level")))
	if get_parent().get_child(3):
		#print(get_parent().get_child(3))
		#print(is_instance_valid(get_parent().get_child(3).get_node("Player")))
		if is_instance_valid(get_parent().get_child(3).get_node("Player")):
			heat_meter.value = get_parent().get_child(3).get_node("Player").current_temperature
	
	mineral_meter.value = get_parent().level.minerals_gathered
	if mineral_meter.value >= get_parent().level.mineral_goal:
		$NextLevel.visible = true
	elif $NextLevel.visible:
		$NextLevel.visible = false

