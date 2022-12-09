extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tips_visible
onready var tips = get_parent().get_parent().get_parent().get_node("Tips")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed = false
	tips.visible = $Button.pressed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Button.pressed:
		modulate = Color.green
	else:
		modulate = Color.white



func _on_Button_toggled(button_pressed):
	tips.visible = button_pressed
	get_tree().paused = button_pressed
