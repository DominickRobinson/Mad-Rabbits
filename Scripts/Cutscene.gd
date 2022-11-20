extends Node2D


onready var cutscene = $CutscenePlayer

func _ready():
	Manager.set_cutscene_mode()
	#yield(get_tree().create_timer(3.0), "timeout")
#	if is_instance_valid(cutscene):
#		cutscene.play("cutscene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
