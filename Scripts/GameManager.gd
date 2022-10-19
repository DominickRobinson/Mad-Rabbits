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

var gaveUp = false

onready var currentPlayer
onready var cameraController

func _ready():
	currentPlayer = findPlayer()
	cameraController = findCamera()
	pass

func slowdown(p=0.2):
	Engine.time_scale = p
	dampAllAudio(p)
	cameraController.slowMotion()
	
func speedup():
	normalAllAudio()
	Engine.time_scale = 1
	cameraController.normalMotion()

func _process(delta):
	
	if not get_tree().current_scene.is_in_group("Level"):
		return
	
	currentPlayer = findPlayer()
	cameraController = findCamera()
	
	if Input.is_action_pressed("slowmo"):
		slowdown(0.2)
	elif Input.is_action_just_released("slowmo"):
		speedup()
		
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
	get_tree().change_scene(ConvertLevelToFile(Manager.LevelIndex))
	ResetGameManager()
	
func NextLevel():
	Manager.LevelIndex += 1
	RestartLevel()

func ConvertLevelToFile(level):
	var file = str("res://Scenes/Levels/" + Manager.Levels[level] + ".tscn")
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

func dampAllAudio(p=0.2):
	var audioPlayers = get_tree().get_nodes_in_group("dampable")
	for audio in audioPlayers:
		if audio is AudioStreamPlayer and audio != null:
			audio = audio as AudioStreamPlayer
			audio.volume_db = -1
			audio.pitch_scale = p

func normalAllAudio():
	var audioPlayers = get_tree().get_nodes_in_group("dampable")
	for audio in audioPlayers:
		if audio != null and audio is AudioStreamPlayer:
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


func playAudio(file, vol = 0, dampable = true):
	var a = AudioStreamPlayer.new()
	add_child(a)
	if dampable:
		a.add_to_group("dampable")
	a.stream = load(file)
	a.volume_db = vol
	a.play()
	
	yield(a, "finished")
	a.queue_free()



func wait(time):
	yield(get_tree().create_timer(time), "timeout")
