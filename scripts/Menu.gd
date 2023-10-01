extends Control

onready var label = $Panel/VBoxContainer/Label
onready var h_slider = $Panel/VBoxContainer/HSlider
onready var label_2 = $Panel/VBoxContainer/Label2
onready var h_slider_2 = $Panel/VBoxContainer/HSlider2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button2_pressed():
	h_slider_2.visible = !h_slider_2.visible
	label_2.visible = !label_2.visible
	h_slider.visible = !h_slider.visible
	label.visible = !label.visible


func _on_Button_pressed():
	visible = false
