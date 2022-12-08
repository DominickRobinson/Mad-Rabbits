extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _unhandled_input(event):
	if Input.is_action_just_pressed("zoom_in_test"):
		zoom *= 0.9
	if Input.is_action_just_pressed("zoom_out_test"):
		zoom *= 1.1
		
