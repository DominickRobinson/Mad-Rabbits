extends AnimationPlayer


export var AUTO_START := false

func _ready():
	if AUTO_START:
		play("cutscene")





func _on_Button_toggled(button_pressed):
	if button_pressed:
		play("cutscene")
	else:
		stop(false)
