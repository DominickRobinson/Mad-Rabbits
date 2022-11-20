extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Button.pressed:
		modulate = Color.green
	else:
		modulate = Color.white




func _on_Button_toggled(button_pressed):
	get_parent().get_parent().get_parent().pause(button_pressed)
