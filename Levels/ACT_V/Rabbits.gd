extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func yay():
	var children = get_children()
	for c in children:
		c = c as RigidBody2D
		c.mode = RigidBody2D.MODE_RIGID
		c.can_always_control = true
