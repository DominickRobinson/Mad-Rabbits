extends Control

onready var button = $Button



func _ready():
	pass

func _process(delta):
	if $Button.pressed:
		modulate = Color.green
	else:
		modulate = Color.white


func _on_Button_pressed():
	#print("plz give up")
	Manager.next_level()
