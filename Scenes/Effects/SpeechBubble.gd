extends Node2D

var dialogue = "*insert text here*"
var time = 5

var characterToFollow



onready var label = $VBoxContainer/Label

func _process(delta):
	global_position = characterToFollow.global_position
	pass

func begin():
	start()
	yield(get_tree().create_timer(time), "timeout")	
	end()


func start():
	visible = true
	label.text = dialogue


func end():
	queue_free()



