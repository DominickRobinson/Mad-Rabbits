extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sp := $Sprite
var tex1 := preload("res://Scenes/SceneTransition/book/02.png")
var tex2 := preload("res://Scenes/SceneTransition/book/03.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(_event):
	if Input.is_key_pressed(KEY_SPACE):
		sp.texture = tex1
	else:
		sp.texture = tex2
		
