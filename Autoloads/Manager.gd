extends Node

var rng = RandomNumberGenerator.new()
onready var bubble_root = preload("res://Scenes/Bubble.tscn")


var Levels = ["ACT_0/0-0", "ACT_0/0-1", "ACT_0/0-2",
	
			  "ACT_I/1-0c",
			  "ACT_I/1-1l", "ACT_I/1-2c", "ACT_I/1-3l", "ACT_I/1-4c", "ACT_I/1-5l", "ACT_I/1-6c", 
			  "ACT_I/1-7l", "ACT_I/1-8c", "ACT_I/1-9l", "ACT_I/1-10c", "ACT_I/1-11l", "ACT_I/1-12c", 
			  "ACT_I/1-13l", "ACT_I/1-14c", "ACT_I/1-15c", "ACT_I/1-16l", "ACT_I/1-17c", "ACT_I/1-18l", 
			  "ACT_I/1-19c",
			
			  "ACT_II/2-0c",
			  "ACT_II/2-1l", "ACT_II/2-2c", "ACT_II/2-3l", "ACT_II/2-4c", "ACT_II/2-5c", "ACT_II/2-6c",
			  "ACT_II/2-7l", "ACT_II/2-8l", "ACT_II/2-9c", "ACT_II/2-10l", "ACT_II/2-11c", "ACT_II/2-12l", 
			  "ACT_II/2-13c", "ACT_II/2-14c", "ACT_II/2-15l", "ACT_II/2-16c", "ACT_II/2-17l", 
			  "ACT_II/2-18c", "ACT_II/2-19c", "ACT_II/2-20l", "ACT_II/2-21c", "ACT_II/2-22l", 
			  "ACT_II/2-23l", "ACT_II/2-24c", "ACT_II/2-25c",
			  
			  "ACT_III/3-0c",
			  "ACT_III/3-1c", "ACT_III/3-2c", "ACT_III/3-3c", "ACT_III/3-4c", "ACT_III/3-5l", 
			  "ACT_III/3-6c", "ACT_III/3-7l", "ACT_III/3-8c", "ACT_III/3-9c", "ACT_III/3-10l", 
			  "ACT_III/3-11c", "ACT_III/3-12l", "ACT_III/3-13c", "ACT_III/3-14l", "ACT_III/3-15c", 
			  "ACT_III/3-16l", "ACT_III/3-17c",
			
			  "ACT_IV/4-0c",
			  "ACT_IV/4-1c", "ACT_IV/4-2c", "ACT_IV/4-3c", "ACT_IV/4-4l", "ACT_IV/4-5c", "ACT_IV/4-6l", 
			  "ACT_IV/4-7c", "ACT_IV/4-8c", "ACT_IV/4-9l","ACT_IV/4-10c", "ACT_IV/4-11c", "ACT_IV/4-12c",
			
			  "ACT_V/5-0c",
			  "ACT_V/5-1c", "ACT_V/5-2c"]


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
	print("There are ", Levels.size(), " levels!")
	var sling_count = 0
	for l in Levels:
		if "l" in l:
			sling_count += 1
	print("  " + str(sling_count) + " of these are action levels!")
	print("  The other " + str(Levels.size()-sling_count) + " are cutscenes!")

func _process(delta):
	pass


func _unhandled_input(event):
#	if Input.is_action_just_pressed("slowmo_on"):
#		slowdown()
#	if Input.is_action_just_pressed("slowmo_off"):
#		speedup()
	
	if Input.is_action_just_pressed("next_level"):
		next_level()
	if Input.is_action_just_pressed("prev_level"):
		last_level()
	
	if Input.is_action_just_pressed("quit"):
		quit()
	if Input.is_action_just_pressed("reload"):
		reload()
	
	if Input.is_action_just_pressed("screenshot"):
		Input.action_press("hide_ui")
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		yield(get_tree(), "physics_frame")
		yield(get_tree(), "physics_frame")
		yield(get_tree(), "physics_frame")
		yield(get_tree(), "physics_frame")
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("res://Screenshots/" + get_tree().current_scene.get_name() + ".png")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
#	if findCamera() != null:
#		if Input.is_action_just_pressed("zoom_in_test"):
#			findCamera().zoom *= .9
#		if Input.is_action_just_pressed("zoom_out_test"):
#			findCamera().zoom *= 1.1



#helper level
func reload():
	ChangeScene.display_flip = false
	speedup()
	get_tree().reload_current_scene()

#page flip animation - goes to next level in array
func next_level():
	speedup()
	get_tree().paused = false
	Manager.LevelIndex += 1
	#RestartLevel()
	ChangeScene.display_flip = true
	ChangeScene.flip_left = true
#	if Manager.LevelIndex >= Levels.size():
#		LevelIndex = 0
#		ChangeScene.change_scene(ConvertLevelToFile(Manager.LevelIndex))
#		return
	ChangeScene.change_scene(ConvertLevelToFile(Manager.LevelIndex))

#page flip animation - goes to last level in array
func last_level():
	speedup()
	get_tree().paused = false
	Manager.LevelIndex -= 1
	#RestartLevel()
	ChangeScene.display_flip = true
	ChangeScene.flip_left = false
#	if Manager.LevelIndex < 0:
#		Manager.LevelIndex = 0
#		return
	ChangeScene.change_scene(ConvertLevelToFile(Manager.LevelIndex))

#page flip animaton - goes to given level with index num
func go_to_level(num):
	speedup()
	get_tree().paused = false
	var old_index = LevelIndex
	ChangeScene.display_flip = true
	Manager.LevelIndex = num 
	#RestartLevel()
	if Manager.LevelIndex >= Levels.size() or Manager.LevelIndex <= 0 or LevelIndex == old_index:
		return
	if LevelIndex < old_index:
		ChangeScene.flip_left = false
	else:
		ChangeScene.flip_left = true
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

func quit():
	speedup()
	get_tree().quit()


func playAudio(file, vol = 0, dampable = true):
	var a = AudioStreamPlayer.new()
	get_tree().get_current_scene().add_child(a)
	if dampable:
		a.add_to_group("dampable")
	a.stream = load(file)
#	a.stream = load("res://Assets/Sound/Music/battling_god.mp3")
	a.volume_db = vol
	a.play()
	
	yield(a, "finished")
	a.queue_free()


func playMusic(music):
	playAudio(music, -5, false)


func slowdown(p=0.2):
	Engine.time_scale = p
	dampAllAudio(p)
#	if findCamera() != null:
#		findCamera().slowMotion()
	
func speedup():
	normalAllAudio()
	Engine.time_scale = 1
#	if findCamera() != null:
#		findCamera().normalMotion()

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

func get_number_of_rabbits_left():
	return get_tree().get_nodes_in_group("Player").size()

#gets the last rabbit thrown (useful for zooming in when abilities cant be manually activated
func last_rabbit_thrown():
	if is_instance_valid(get_tree().get_current_scene().get_node("Slingshot")):
#		return get_tree().get_current_scene().get_node("Slingshot").lastRabbitThrown
		return get_tree().get_current_scene().lastRabbitThrown
	else:
		return null


func set_last_rabbit_thrown(rabbit):
	print(rabbit)
	if is_instance_valid(get_tree().get_current_scene().get_node("Slingshot")):
#		get_tree().get_current_scene().get_node("Slingshot").lastRabbitThrown = rabbit
		get_tree().get_current_scene().lastRabbitThrown = rabbit


func findCamera():
	if get_tree().get_nodes_in_group("LevelCamera").size() > 0:
		return get_tree().get_nodes_in_group("LevelCamera")[0]
	else:
		return null

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


func play_music(song : String):
#	var soundtrack = {
#		"triumphant": pass,
#		"elegant": pass,
#		"ambient": pass,
#		"happy/slightly chill": pass,
#		"tense/ominous": pass,
#		"hopeful": pass,
#		"title": pass,
#		"church": pass,
#		"iconic/chaotic": pass,
#		"villainous": pass
#		}
	
	var song_filename = "res://Assets/Sound/Music/" + song + ".mp3"
#	song_filename =  "res://Assets/Sound/Music/iconic_chaos.mp3"
	#print(song_filename)
	playAudio(song_filename, -5, false)
