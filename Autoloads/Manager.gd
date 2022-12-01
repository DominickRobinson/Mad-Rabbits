extends Node

var rng = RandomNumberGenerator.new()
onready var bubble_root = preload("res://Scenes/Bubble.tscn")

var Levels = ["ACT I/1-1l", "ACT I/1-2c", "ACT I/1-3l", "ACT I/1-4c", "ACT I/1-5l", "ACT I/1-6c", "ACT I/1-7l" , 
			  "ACT I/1-8c", "ACT I/1-9l", "ACT I/1-10c", "ACT I/1-11l", "ACT I/1-12c", "ACT I/1-13l", "ACT I/1-14c", 
			  "ACT I/1-15c", "ACT I/1-17c", "ACT I/1-18l", "ACT I/1-19c",
			  "ACT III/3-1c", "ACT III/3-2c", "ACT III/3-3c", "ACT III/3-4c", "ACT III/3-5l", "ACT III/3-6c", "ACT III/3-7l", 
			  "ACT III/3-8c", "ACT III/3-9c", "ACT III/3-10l", "ACT III/3-11l", "ACT III/3-12l", "ACT III/3-13c", "ACT III/3-14l", 
			  "ACT III/3-15c", "ACT III/3-16l", "ACT III/3-17c", "ACT III/3-19c",
			  "ACT IV/4-1c", "ACT IV/4-2c", "ACT IV/4-3c", "ACT IV/4-4l", "ACT IV/4-5c", "ACT IV/4-6l", "ACT IV/4-7c", 
			  "ACT IV/4-8c", "ACT IV/4-10c", "ACT IV/4-11c", "ACT IV/4-12c",
			  "ACT V/5-1c", "ACT V/5-2c"]
var LevelIndex = 0

enum GameModes {
	MainMenu,
	Level,
	Cutscene
}

var CurrentGameMode
var slowmo = false
var Score = 0
var gaveUp = false


func _ready():
	CurrentGameMode = GameModes.MainMenu

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		quit()
	if Input.is_action_just_pressed("reload"):
		reload()

func _unhandled_input(event):
	if Input.is_action_just_pressed("slowmo_on"):
		slowdown()
	if Input.is_action_just_pressed("slowmo_off"):
		speedup()
	
	if Input.is_action_just_pressed("zoom_in_test"):
		findCamera().zoom *= .9
	if Input.is_action_just_pressed("zoom_out_test"):
		findCamera().zoom *= 1.1


#helper level
func RestartLevel():
	#reloads scene
	speedup()
	get_tree().change_scene(ConvertLevelToFile(Manager.LevelIndex))

#page flip animation - goes to next level in array
func next_level():
	speedup()
	Manager.LevelIndex += 1
	#RestartLevel()
	if Manager.LevelIndex >= Levels.size():
		Manager.LevelIndex = 0
	ChangeScene.change_scene(ConvertLevelToFile(Manager.LevelIndex))

#page flip animation - goes to last level in array
func last_level():
	speedup()
	Manager.LevelIndex -= 1
	#RestartLevel()
	if Manager.LevelIndex < 0:
		Manager.LevelIndex = 0
		return
	ChangeScene.change_scene(ConvertLevelToFile(Manager.LevelIndex))

#page flip animaton - goes to given level with index num
func go_to_level(num):
	speedup()
	Manager.LevelIndex = num 
	#RestartLevel()
	if Manager.LevelIndex >= Levels.size() or Manager.LevelIndex <= 0:
		return
	ChangeScene.change_scene(ConvertLevelToFile(Manager.LevelIndex))


func ConvertLevelToFile(level):
	var file = str("res://Levels/" + Manager.Levels[level] + ".tscn")
	#print(file)
	return file
#helper level



func set_level_mode():
	CurrentGameMode = GameModes.Level
	
	
func set_cutscene_mode():
	CurrentGameMode = GameModes.Cutscene


func reload():
	speedup()
	get_tree().reload_current_scene()

func quit():
	speedup()
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

func playMusic(music):
	playAudio(music, -5, false)


func slowdown(p=0.2):
	Engine.time_scale = p
	dampAllAudio(p)
	findCamera().slowMotion()
	
func speedup():
	normalAllAudio()
	Engine.time_scale = 1
	findCamera().normalMotion()

func dampAllAudio(p=0.2):
	var audioPlayers = get_tree().get_nodes_in_group("dampable")
	for audio in audioPlayers:
		if audio != null and audio is AudioStreamPlayer:
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

func get_player():
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		return players[0]
	else:
		return null

#gets the last rabbit thrown (useful for zooming in when abilities cant be manually activated
func last_rabbit_thrown():
	if is_instance_valid(get_tree().get_current_scene().get_node("Slingshot")):
		return get_tree().get_current_scene().get_node("Slingshot").lastRabbitThrown
	else:
		return null


func findCamera():
	return get_tree().get_nodes_in_group("LevelCamera")[0]


func makePOW(node, word, color, location, rng_range):
	rng.randomize()
	var rand1 = rng.randf_range(-rng_range, rng_range)
	var rand2 = rng.randf_range(-rng_range, rng_range)
	var bubble = bubble_root.instance()
	bubble = bubble as Control
	node.add_child(bubble)
	bubble.text = word
	bubble.bubble_color = color
	bubble.update()
	bubble.rect_global_position = location
	bubble.rect_position.x += rand1
	bubble.rect_position.y += rand2



func get_level():
	var currScene = get_tree().current_scene
	return currScene
