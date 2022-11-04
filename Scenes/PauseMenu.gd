extends Control


var is_paused = false setget set_is_paused



onready var narratorButton = $CenterContainer/VBoxContainer/OptionsList/NarratorButton
onready var storytextButton = $CenterContainer/VBoxContainer/OptionsList/StorytextButton
onready var abilityZoomButton = $CenterContainer/VBoxContainer/OptionsList/AbilityZoomButton
onready var showCatchphraseButton = $CenterContainer/VBoxContainer/OptionsList/AbilityCatchphraseButton



func _ready():
	narratorButton.pressed = Options.storytextNarrator
	storytextButton.pressed = Options.storytextVisible
	abilityZoomButton.pressed = Options.zoomInDuringAbility
	showCatchphraseButton.pressed = Options.abilityCatchphraseVisible

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		set_is_paused(not is_paused)

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused




func _on_NarratorButton_toggled(button_pressed):
	Options.storytextNarrator = button_pressed

func _on_StorytextButton_toggled(button_pressed):
	Options.storytextVisible = button_pressed

func _on_AbilityZoomButton_toggled(button_pressed):
	Options.zoomInDuringAbility = button_pressed

func _on_AbilityCatchphraseButton_toggled(button_pressed):
	Options.abilityCatchphraseVisible = button_pressed


func _on_RestartLevel_pressed():
	set_is_paused(false)
	Manager.reload()

func _on_QuitGame_pressed():
	Manager.quit()



func _on_Unpause_button_down():
	set_is_paused(false)
