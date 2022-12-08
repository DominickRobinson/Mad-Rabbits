extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Chapter_1_pressed():
	Manager.go_to_level(3)


func _on_Chapter_2_pressed():
	Manager.go_to_level(23)


func _on_Chapter_3_pressed():
	Manager.go_to_level(49)


func _on_Chapter_4_pressed():
	Manager.go_to_level(67)


func _on_Chapter_5_pressed():
	Manager.go_to_level(80)



func _on_GoToPage_pressed():
	Manager.go_to_level($PageNumber/HBoxContainer/SpinBox.value - 1)
