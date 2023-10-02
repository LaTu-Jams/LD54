extends Control

onready var label = $Panel/VBoxContainer/Label
onready var h_slider = $Panel/VBoxContainer/HSlider
onready var label_2 = $Panel/VBoxContainer/Label2
onready var h_slider_2 = $Panel/VBoxContainer/HSlider2


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/VBoxContainer/MusicSlider.max_value = MusicManager.MAX_DB
	$Panel/VBoxContainer/MusicSlider.min_value = MusicManager.MUTE_DB
	$Panel/VBoxContainer/MusicSlider.value = -20

	$Panel/VBoxContainer/SoundSlider.max_value = SoundManager.MAX_DB
	$Panel/VBoxContainer/SoundSlider.min_value = SoundManager.MUTE_DB
	$Panel/VBoxContainer/SoundSlider.value = -15

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button2_pressed():
	h_slider_2.visible = !h_slider_2.visible
	label_2.visible = !label_2.visible
	h_slider.visible = !h_slider.visible
	label.visible = !label.visible


func _on_Button_pressed():
	if get_tree().current_scene.game_started:
		get_tree().paused = false
	visible = false


func _on_music_changed(value):
	MusicManager._on_range_change(value)



func _on_sound_changed(value):
	SoundManager._on_range_change(value)
