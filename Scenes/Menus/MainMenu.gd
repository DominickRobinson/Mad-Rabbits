extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("start")
	Manager.playMusic("res://Assets/Sound/Music/Scott Holmes Music - Beyond Dreams.mp3")




func _unhandled_input(event):
	if Input.is_action_just_pressed("ability"):
		print("hello")
		$AnimationPlayer.advance(100.0)



func _on_Classic_pressed():
	var level_num = Manager.LevelIndex
	var level_file = Manager.ConvertLevelToFile(level_num)
	
	ChangeScene.change_scene(level_file)
