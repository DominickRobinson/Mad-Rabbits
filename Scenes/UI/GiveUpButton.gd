extends Control

onready var button = $Button



func _ready():
	pass




func _on_Button_pressed():
	print("plz give up")
	Manager.get_scene().gaveUp = true
