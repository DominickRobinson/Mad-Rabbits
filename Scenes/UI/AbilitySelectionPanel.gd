extends Control

var last_pressed : Button = null

func _ready() -> void:
	for button in get_children():
		button.connect("toggled", self, "_on_Button_toggled", [button])

func _on_Button_toggled(is_pressed: bool, button: Button) -> void:
	if last_pressed == button:
		button.pressed = false
		last_pressed = null
		var num = int(button.get_name()[7])
		print(button.name(), ": ", num)
		#GameManager.currentPlayer.set_ability()
	else:
		last_pressed = button
