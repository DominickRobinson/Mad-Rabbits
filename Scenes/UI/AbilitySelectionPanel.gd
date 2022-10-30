extends CanvasLayer

#var buttons = get_children()[0].get_children()
var buttons

func _ready() -> void:
	toggle_visibility(false)
	buttons = $Control/HBoxContainer.get_children()
	for button in buttons:
		button.connect("pressed", self, "_on_Button_pressed", [button])
		if get_button_number(button) > get_parent().totalAbilities:
			button.hide()

func _on_Button_pressed(button: Button) -> void:
	var num = get_button_number(button)
	print("Ability selected: ", num)
	Manager.get_level().get_player().set_ability(num)
	
	for b in buttons:
		b.pressed = (button == b)

func toggle_visibility(show):
	if show:
		$Control.show()
	else:
		$Control.hide()

func get_button_number(button: Button):
	return int(button.get_name()[7])
