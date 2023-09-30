extends CanvasLayer
class_name UIManager

onready var heat_meter := $HeatMeter


func initialize():
	heat_meter.max_value = get_parent().player.max_temperature
	heat_meter.value = get_parent().player.current_temperature


func _process(delta):
	heat_meter.value = get_parent().player.current_temperature

