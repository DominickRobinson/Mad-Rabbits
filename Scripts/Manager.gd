extends Node


enum GameModes {
	Level,
	Cutscene
}

var currentGameMode = GameModes.Cutscene

func _ready():
	manageAutoloads()
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func manageAutoloads():
	match currentGameMode:
		
		GameModes.Level:
			pass
	
func speedup(speed):
	Engine.time_scale = speed
