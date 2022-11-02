extends Node

var rng = RandomNumberGenerator.new()
var bubble_root = load("res://Scenes/Bubble.tscn")

var Levels = ["Test/GameLoop", "Test/GameLoop"]
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


#helper level
func RestartLevel():
	#reloads scene
	get_tree().change_scene(ConvertLevelToFile(Manager.LevelIndex))
	speedup()

func next_level():
	Manager.LevelIndex += 1
	RestartLevel()
	speedup()

func ConvertLevelToFile(level):
	var file = str("res://Scenes/Levels/" + Manager.Levels[level] + ".tscn")
	#print(file)
	return file
#helper level



func set_level_mode():
	CurrentGameMode = GameModes.Level
	
	
func set_cutscene_mode():
	CurrentGameMode = GameModes.Cutscene


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
	node.add_child(bubble)
	bubble = bubble as Control
	bubble.text = word
	bubble.bubble_color = color
	bubble.update()
	bubble.rect_global_position = location
	bubble.rect_position.x += rand1
	bubble.rect_position.y += rand2


func get_level():
	var currScene = get_tree().current_scene
	return currScene
