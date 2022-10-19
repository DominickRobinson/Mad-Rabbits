extends Node

var Levels = ["Test/GameLoop", "Test/GameLoop"]
var LevelIndex = 0

enum GameModes {
	Level,
	Cutscene
}

var currentGameMode



func _ready():
	currentGameMode = GameModes.Level

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func levelMode():
	currentGameMode = GameModes.Level
	
	
func cutsceneMode():
	currentGameMode = GameModes.Cutscene

func speedup(speed):
	Engine.time_scale = speed
