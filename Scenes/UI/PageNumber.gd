extends Control

onready var sb = $HBoxContainer/SpinBox

func _ready():
	sb.value = Manager.LevelIndex + 1
	$Num.text = "" + str(Manager.LevelIndex + 1)



func _on_ForwardPage_pressed():
	Manager.next_level()


func _on_BackPage_pressed():
	Manager.last_level()


func _on_GoToPage_pressed():
	Manager.go_to_level(sb.value - 1)
