extends Node


enum GameState {
	Start,
	Play,
	Win,
	Lose
}




var CurrentGameState = GameState.Start
var Score = 0

var gaveUp = false
var slowmo = false

onready var currentPlayer
onready var cameraController
onready var currentCamera

onready var screen = $ScreenEffects

func _ready():
	if not get_tree().current_scene.is_in_group("Level"):
		return
	currentPlayer = get_current_player()
	#currentCamera = findCamera()
	
	#disable collisions between rabbits
#	var rabbits = get_tree().get_nodes_in_group("Rabbits")
#	for r in rabbits:
#		for r2 in rabbits:
#			if r != r2:
#				print(r.get_name(), " | ", r2.get_name())
#				r.add_collision_exception_with(r2)
	
	
	

func slowdown(p=0.2):
	Engine.time_scale = p
	dampAllAudio(p)
	findCamera().slowMotion()
	
func speedup():
	normalAllAudio()
	Engine.time_scale = 1
	findCamera().normalMotion()

func _unhandled_input(event):
	if Input.is_action_just_pressed("slowmo_on"):
		slowdown()
	if Input.is_action_just_pressed("slowmo_off"):
		speedup()
	



func _process(delta):
	
	if not get_tree().current_scene.is_in_group("Level"):
		return
	
#	if slowmo:
#		slowdown()
#	else:
#		speedup()
	
	currentPlayer = get_current_player()
	currentCamera = findCamera()
	
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
			currentPlayer = get_current_player()
			#cameraController = findCamera()
			#print("start")
			CurrentGameState = GameState.Play
		GameState.Play:
			#var rabbits = get_tree().get_nodes_in_group("Rabbits")
			var bears = get_tree().get_nodes_in_group("Bears")
			#var players = get_tree().get_nodes_in_group("Player")
			
			#win condition
			if bears.size() <= 0:
				CurrentGameState = GameState.Win
			else:
				#manual give up = lose
				if gaveUp:
					CurrentGameState = GameState.Lose
			
			#updates score	
			get_tree().get_nodes_in_group("InterfaceController")[0].SetScore()
		
		GameState.Win:
			#level win endscreen
			get_tree().get_nodes_in_group("InterfaceController")[0].PopupLevelCompleted(true, Score)
			
		GameState.Lose:
			#level lose endscreen
			get_tree().get_nodes_in_group("InterfaceController")[0].PopupLevelCompleted(false, 0)


func RestartLevel():
	#reloads scene
	get_tree().change_scene(ConvertLevelToFile(Manager.LevelIndex))
	#resets stuff
	ResetGameManager()
	
func NextLevel():
	Manager.LevelIndex += 1
	RestartLevel()

func ConvertLevelToFile(level):
	var file = str("res://Scenes/Levels/" + Manager.Levels[level] + ".tscn")
	print(file)
	return file
	
	


func wait(time):
	yield(get_tree().create_timer(time), "timeout")


