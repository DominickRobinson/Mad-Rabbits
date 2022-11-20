extends Node2D

export var dialogue := "*insert text here"
export var time := 5

var characterToFollow



onready var label = $VBoxContainer/Label

func _process(delta):
	if is_instance_valid(characterToFollow):
		global_position = characterToFollow.global_position


func begin():
	start()
	yield(get_tree().create_timer(time), "timeout")	
	end()


func start():
	visible = true
	label.text = dialogue


func end():
	queue_free()



