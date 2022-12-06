extends AnimationPlayer


export var AUTO_START := false
onready var button = $Control/NinePatchRect/Button

func _ready():
	$Control.visible = true
	if AUTO_START:
		button.pressed = true


func _unhandled_key_input(event):
	if Input.is_action_just_pressed("hide_ui"):
		print("hiii")
		$Control.visible = not $Control.visible


func _on_Button_toggled(button_pressed):
	if button_pressed:
		play("cutscene")
		button.queue_free()
	else:
		stop(false)
	
	$Control.modulate.a8 = 128
	$Control.visible = false
