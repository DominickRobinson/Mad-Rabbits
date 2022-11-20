extends Control

#export (String, MULTILINE) var text := "There once was a rabbit..."


var currChars = 0
var totalChars

onready var tween = $Tween
onready var label = $VBoxContainer/Label
onready var visibilityButton = $ToggleVisibility

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "     " + label.text
	totalChars = len(label.text)
	label.visible_characters = 0
	set_visibility(visibilityButton.pressed)
	show_all_chars(totalChars * 0.05)


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
	label.visible = Options.storytextVisible and button_pressed
