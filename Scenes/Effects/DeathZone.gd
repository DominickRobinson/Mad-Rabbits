extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DeathZone_body_entered(body):
	if body.is_in_group("Rabbits"):
		if body == Manager.get_player():
			if Manager.get_number_of_rabbits_left() == 1:
				get_tree().reload_current_scene()
			else:
				Input.action_press("return_to_slingshot")
#				print("1111")
				yield(get_tree(), "physics_frame")
#				print("2222")
				yield(get_tree(), "physics_frame")
#				print("3333")
				yield(get_tree(), "physics_frame")
#				print("4444")
				Input.action_release("return_to_slingshot")
#				print("5555")
