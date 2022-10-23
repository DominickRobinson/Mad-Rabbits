extends Node2D

export (String, MULTILINE) var text := "There once was a rabbit..."


var currChars = 0
var totalChars = len(text)

onready var tween = $Tween

onready var label = $VBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "     " + text
	totalChars = len(text)
	label.text = text
	currChars = 0
	label.visible_characters = 0
	
	print(totalChars)
	print(label.visible_characters)
	
	show_all_chars(5)

func _physics_process(delta):
	visible = Options.storytextVisible


func show_chars(newChars, time):
	tween.interpolate_property(label, "visible_characters", currChars, newChars, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	print("start")
	
	yield(tween, "tween_completed")
	print("done")
	currChars = newChars

func show_all_chars(time):
	show_chars(totalChars, time)


