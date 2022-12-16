extends Control

#export (String, MULTILINE) var text := "There once was a rabbit..."


var currChars = 0
var totalChars

onready var tween = $Tween
onready var label = $VBoxContainer/Label
onready var visibilityButton = $Control/NinePatchRect/ToggleVisibility

export var disable := false

# Called when the node enters the scene tree for the first time.
func _ready():
	if disable:
		queue_free()
#	label.text = "     " + label.text
#	yield(get_tree().create_timer(0.1), "timeout")
	totalChars = len(label.text)
	print(totalChars)
	label.visible_characters = 0
	set_visibility(visibilityButton.pressed)
	show_all_chars(totalChars * 0.025)


func _process(delta):
	set_visibility(visibilityButton.pressed)


func show_chars(newChars, time):
	tween.interpolate_property(label, "visible_characters", currChars, newChars, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	currChars = newChars


func show_all_chars(time):
	show_chars(totalChars, time)


func set_visibility(button_pressed):
	label.visible = button_pressed
	visible = Options.storytextVisible
	
	if not button_pressed:
		modulate.a8 = 128
	else:
		modulate.a8 = 255
