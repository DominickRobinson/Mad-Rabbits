extends Node2D

export (String, FILE, "*.mp3") var music := ""

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
var slowmo = false

onready var currentPlayer
onready var cameraController
onready var currentCamera

export var space_level := false


func _ready():
	if has_node("LevelCamera"):
		$LevelCamera.current = true
		
	get_tree().paused = false
	Manager.set_level_mode()
	self.add_to_group("Level")
	Manager.playMusic(music)
	if not get_tree().current_scene.is_in_group("Level"):
		return
	currentPlayer = Manager.get_player()
	speedup()
#	print(Physics2DServer.AREA_PARAM_GRAVITY_VECTOR)
	if space_level:
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2.ZERO)
	else:
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2.DOWN)
		
	print(space_level)
	print(Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR))


func slowdown(p=0.2):
	Engine.time_scale = p
	Manager.dampAllAudio(p)
	Manager.findCamera().slowMotion()
	
func speedup():
	Manager.normalAllAudio()
	Engine.time_scale = 1
	Manager.findCamera().normalMotion()

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
	
	currentPlayer = Manager.get_player()
	currentCamera = Manager.findCamera()
	
	if Input.is_action_pressed("slowmo"):
		slowdown(0.2)
	elif Input.is_action_just_released("slowmo"):
		speedup()
		
	if is_instance_valid(currentPlayer):
		if Input.is_action_pressed("spin_up"):
			currentPlayer.angular_velocity += 1
		elif Input.is_action_pressed("spin_down"):
			currentPlayer.angular_velocity -= 1
	
	
	match CurrentGameState:
		GameState.Start:
			currentPlayer = Manager.get_player()
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
			

		
		GameState.Win:
			#level win endscreen
			get_tree().get_nodes_in_group("InterfaceController")[0].PopupLevelCompleted(true)
			
		GameState.Lose:
			#level lose endscreen
			get_tree().get_nodes_in_group("InterfaceController")[0].PopupLevelCompleted(false)


#func RestartLevel():
#	#reloads scene
#	get_tree().change_scene(ConvertLevelToFile(Manager.LevelIndex))
#	speedup()
#
#
#func NextLevel():
#	Manager.LevelIndex += 1
#	RestartLevel()
#	speedup()
#
#func ConvertLevelToFile(level):
#	var file = str("res://Scenes/Levels/" + Manager.Levels[level] + ".tscn")
#	#print(file)
#	return file


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


func wait(time):
	yield(get_tree().create_timer(time), "timeout")

#gets the last rabbit thrown (useful for zooming in when abilities cant be manually activated
func last_rabbit_thrown():
	if is_instance_valid(get_tree().get_current_scene().get_node("Slingshot")):
		return get_tree().get_current_scene().get_node("Slingshot").lastRabbitThrown
	else:
		return null

func get_player():
	#print("YEEEET")
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		return players[0]
	else:
		return null

func get_camera():
	return get_tree().get_nodes_in_group("LevelCamera")[0]

