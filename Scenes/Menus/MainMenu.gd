extends Control


var click_counter = 0

func _ready():
	#play title music
	Manager.playMusic("res://Assets/Sound/Music/Scott Holmes Music - Beyond Dreams.mp3")
	
	#title animation
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer1.play("start")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	$Text.visible = true

	#wait for some amount of time before character animation
	yield($AnimationPlayer1, "animation_finished")
#	yield(get_tree().create_timer(5), "timeout")

	#character animation
	$AnimationPlayer2.play("cutscene")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	$Sprites.visible = true

func _physics_process(delta):
	if Input.is_action_just_pressed("ability"):
#		$PageNumber.visible = true
		$Text.visible = true
		$Sprites.visible = true
		$AnimationPlayer1.seek(100)
		$AnimationPlayer2.seek(100)


#func _unhandled_input(event):
#	if Input.is_action_just_pressed("ability"):
#		click_counter += 1
##		print(str(click_counter))
#		do_stuff()


func _on_Classic_pressed():
	var level_num = Manager.LevelIndex
	var level_file = Manager.ConvertLevelToFile(level_num)
	
	ChangeScene.change_scene(level_file)


func _on_SpinBox_value_changed(value):
#	print(value)
	Manager.LevelIndex = value - 1



func do_stuff():
	print(click_counter)
	match click_counter:
		1:
			$AnimationPlayer.advance(100.0)
#		2:
#			Manager.go_to_level(1)


func _on_Button_pressed():
	click_counter += 1
	do_stuff()
