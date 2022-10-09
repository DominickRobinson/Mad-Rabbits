extends Node


enum GameModes {
	Level,
	Cutscene
}

var currentGameMode


func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func levelMode():
	currentGameMode = GameModes.Level
	
func cutsceneMode():
	currentGameMode = GameModes.Cutscene

func speedup(speed):
	Engine.time_scale = speed
