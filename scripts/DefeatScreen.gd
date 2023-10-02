extends Control


func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.transparent, 0.5)
	tween.tween_property(self, "visible", false, 0.0)
	$Button.disabled = true
	yield(tween, "finished")
	get_tree().current_scene.restart_level()
