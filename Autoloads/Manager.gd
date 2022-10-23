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
		quit()
	if Input.is_action_just_pressed("reload"):
		reload()

func levelMode():
	currentGameMode = GameModes.Level
	
	
func cutsceneMode():
	currentGameMode = GameModes.Cutscene

func speedup(speed):
	Engine.time_scale = speed


func reload():
	get_tree().reload_current_scene()

func quit():
	get_tree().quit()


func playAudio(file, vol = 0, dampable = true):
	var a = AudioStreamPlayer.new()
	get_tree().get_current_scene().add_child(a)
	if dampable:
		a.add_to_group("dampable")
	a.stream = load(file)
	a.volume_db = vol
	a.play()
	
	yield(a, "finished")
	a.queue_free()


