extends Node2D


onready var cutscene = $CutscenePlayer

func _ready():
	Manager.cutsceneMode()
	#yield(get_tree().create_timer(3.0), "timeout")
	cutscene.play("cutscene")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
