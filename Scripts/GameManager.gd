extends Node2D


enum GameState {
	Start,
	Play,
	Win,
	Lose
}

var bubble_root = load("res://Scenes/Bubble.tscn")
var rng = RandomNumberGenerator.new()

var CurrentGameState = GameState.Start
var Score = 0

var Levels = ["Test/GameLoop", "Test/GameLoop"]
var LevelIndex = 0

var gaveUp = false

onready var currentPlayer
onready var cameraController

func _ready():
	currentPlayer = findPlayer()
	cameraController = findCamera()
	pass

func _process(delta):
	
	currentPlayer = findPlayer()
	cameraController = findCamera()
	
	if Input.is_action_pressed("slowmo"):
		Engine.time_scale = 0.2
		dampAllAudio()
		cameraController.slowMotion()
	elif Input.is_action_just_released("slowmo"):
		normalAllAudio()
		Engine.time_scale = 1
		cameraController.normalMotion()
		
	if Input.is_action_pressed("spin_up"):
		currentPlayer.angular_velocity += 1
	elif Input.is_action_pressed("spin_down"):
		currentPlayer.angular_velocity -= 1
	
	
	match CurrentGameState:
		GameState.Start:
			currentPlayer = findPlayer()
			#cameraController = findCamera()
		GameState.Play:
			
			#currentPlayer = findPlayer()
			var rabbits = get_tree().get_nodes_in_group("Rabbits")
			var bears = get_tree().get_nodes_in_group("Bears")
			var players = get_tree().get_nodes_in_group("Player")
			
			if bears.size() <= 0:
				CurrentGameState = GameState.Win
			else:
#				for r in rabbits:
#					if not r.dead:
#						return true
				if gaveUp and players.size() == 0:
					CurrentGameState = GameState.Lose
				
			get_tree().get_nodes_in_group("InterfaceController")[0].SetScore()
		
		GameState.Win:
			get_tree().get_nodes_in_group("InterfaceController")[0].PopupLevelCompleted(true, Score)
		GameState.Lose:
			get_tree().get_nodes_in_group("InterfaceController")[0].PopupLevelCompleted(false, 0)


func RestartLevel():
	get_tree().change_scene(ConvertLevelToFile(LevelIndex))
	ResetGameManager()
	
func NextLevel():
	LevelIndex += 1
	RestartLevel()

func ConvertLevelToFile(level):
	var file = str("res://Scenes/Levels/" + Levels[level] + ".tscn")
	print(file)
	return file
	
func ResetGameManager():
	CurrentGameState = GameState.Start

func findPlayer():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		return players[0]
	else:
		return currentPlayer

func findCamera():
	return get_tree().get_nodes_in_group("CameraController")[0]

func dampAllAudio():
	var audioPlayers = get_tree().get_nodes_in_group("dampable")
	for audio in audioPlayers:
		print(audioPlayers.size())
		audio = audio as AudioStreamPlayer
		audio.volume_db = -1
		audio.pitch_scale = 0.2

func normalAllAudio():
	var audioPlayers = get_tree().get_nodes_in_group("dampable")
	for audio in audioPlayers:
		audio = audio as AudioStreamPlayer
		audio.volume_db = 0
		audio.pitch_scale = 1

func makePOW(node, word, color, location, rng_range):
	
	rng.randomize()
	var rand1 = rng.randf_range(-rng_range, rng_range)
	var rand2 = rng.randf_range(-rng_range, rng_range)

	var bubble = bubble_root.instance()

	node.add_child(bubble)
	bubble = bubble as Control
	bubble.text = word
	bubble.bubble_color = color
	bubble.update()
	bubble.rect_global_position = location
	bubble.rect_position.x += rand1
	bubble.rect_position.y += rand2

