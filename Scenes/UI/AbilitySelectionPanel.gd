extends CanvasLayer

#var buttons = get_children()[0].get_children()
var buttons

func _ready() -> void:
	toggle_visibility(false)
	buttons = $Control/Container.get_children()
	for button in buttons:
		if button is Button:
			button.connect("pressed", self, "_on_Button_pressed", [button])
			if get_button_number(button) > get_parent().totalAbilities:
				button.hide()
	
	set_button($Control/Container/Ability1)

func _on_Button_pressed(button: Button) -> void:
	var num = get_button_number(button)
	#print("Ability selected: ", num)
	#Manager.get_level().get_player().set_ability(num)
	Manager.get_player().set_ability(num)
	set_button(button)


func set_button(button):
	for b in buttons:
		if not b is Button:
			continue
		b.pressed = (button == b)
		if b.pressed:
			b.modulate = Color.green
		else:
			b.modulate = Color.white

func toggle_visibility(show):
	if show:
		$Control.show()
	else:
		$Control.hide()

func get_button_number(button: Button):
	return int(button.get_name()[7])


