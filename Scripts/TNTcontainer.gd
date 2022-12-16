extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for c in children:
		c.max_health = 1
		c.health = 1
