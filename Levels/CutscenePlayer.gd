extends AnimationPlayer


export var AUTO_START := false

func _ready():
	if AUTO_START:
		$Button.pressed = true





func _on_Button_toggled(button_pressed):
	if button_pressed:
		play("cutscene")
		$Button.queue_free()
	else:
		stop(false)
