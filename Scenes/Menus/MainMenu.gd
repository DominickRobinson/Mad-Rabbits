extends Control


var click_counter = 0

func _ready():
	#play title music
#	Manager.playMusic("res://Assets/Sound/Music/Scott Holmes Music - Beyond Dreams.mp3")
	Manager.playMusic("res://Assets/Sound/Music/title_hopeful.mp3")
	
	#title animation
#	yield(get_tree().create_timer(1), "timeout")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
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
	$GCS_logo.visible = true
	$Sprites.visible = true
	$TipToFlip/AnimationPlayer.play("blink")
	$TipToFlip.visible = true


func _physics_process(delta):
	if Input.is_action_just_pressed("ability"):
		$AnimationPlayer1.playback_speed = 100
		$AnimationPlayer2.playback_speed = 100
#		$PageNumber.visible = true
#		$AnimationPlayer1.seek(100)
#		$AnimationPlayer2.seek(100)
#		$PageNumber.visible = true
#		$Text.visible = true
#		$Sprites.visible = true
#		$GCS_logo.visible = true
#		$GCS_logo.modulate = Color(1,1,1,.7)
#		$TipToFlip.visible = true
#		$TipToFlip/AnimationPlayer.play("blink")
#		$Sprites.modulate = Color(1,1,1,1)



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
