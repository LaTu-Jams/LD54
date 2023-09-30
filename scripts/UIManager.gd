extends CanvasLayer
class_name UIManager

onready var heat_meter := $HeatMeter
onready var mineral_meter := $MineralMeter

func initialize():
	heat_meter.max_value = get_parent().player.max_temperature
	heat_meter.value = get_parent().player.current_temperature
	mineral_meter.max_value = get_parent().level.minerals_in_level
	mineral_meter.value = get_parent().level.minerals_gathered


func _process(delta):
	heat_meter.value = get_parent().player.current_temperature
	mineral_meter.value = get_parent().level.minerals_gathered
	if mineral_meter.value >= get_parent().level.mineral_goal:
		$NextLevel.visible = true
	elif $NextLevel.visible:
		$NextLevel.visible = false

