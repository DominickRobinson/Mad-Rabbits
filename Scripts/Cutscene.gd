extends Node2D

#onready var cutscene = $CutscenePlayer
export var space_level := false

func _ready():
	if space_level:
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2.ZERO)
	else:
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2.DOWN)
	Manager.set_cutscene_mode()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
