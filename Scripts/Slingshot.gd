extends Node2D

enum SlingState {
	idle,
	pulling,
	thrown,
	reset	
}

export var MaxSlingshotPull := 100
export var MaxLaunchVelocity := 400

#onready var currentLevel = get_tree().current_scene
onready var currentLevel = Manager.get_level()

var SlingshotState
var LeftLine
var RightLine
var CenterOfSlingshot
var CenterOfSlingshotGlobal
var player

var lastRabbitThrown

var can_start = false


var left_just_pressed = false
var right_just_pressed = false
var left_pressed = false
var right_pressed = false

var launchNoise = "res://Assets/Sound/SoundEffects/slingshot.mp3"

#variables for ghost trajectory calculator
var GhostTimer = Timer.new()
var ghost_time_to_launch = .75
var rabbit_just_moved_in_slingshot = true
var prevPullPositionGlobal = Vector2.ZERO
var GhostDuplicate = null
var ghost

var velocity



func _ready():
	add_child(GhostTimer)
	GhostTimer.one_shot = true
#	GhostTimer.time_left = ghost_time_to_launch
	SlingshotState = SlingState.idle
	LeftLine = $LeftLine
	RightLine = $RightLine
	CenterOfSlingshot = $CenterOfSlingshot.position
	CenterOfSlingshotGlobal = $CenterOfSlingshot.global_position
	#print(currentLevel.get_name())
	player = currentLevel.get_player()
	reset_slingshot()
	
	wait(1.0)
	#$Tween.interpolate_property(player, "global_position", player.global_position, CenterOfSlingshotGlobal, 1)
	#$Tween.start()
	movePlayerToSlingshot(1)
	
	lastRabbitThrown = player
	

	#print(str(player.position))
	#player.position = CenterOfSlingshot


	
	
func wait(time):
	var t = Timer.new()
	t.set_wait_time(time)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	can_start = true


func _process(delta):
	
	if Input.is_action_just_released("ability"):
		left_pressed = false
		left_just_pressed = false
	if Input.is_action_just_released("return_to_slingshot"):
		right_pressed = false
		right_just_pressed = false
		
	
	match SlingshotState:
		SlingState.idle:
			$CanvasLayer/RabbitControls.mouse_filter = Control.MOUSE_FILTER_IGNORE
			player.showAbilitySelection(true)
			GhostDuplicate = player.duplicate()
			GhostDuplicate.set_collision_mask(0)
			GhostDuplicate.set_collision_layer(0)
		
		SlingState.pulling:
			$CanvasLayer/RabbitControls.mouse_filter = Control.MOUSE_FILTER_PASS
			
			#finds player
			if not can_start:
				return false
			
			#finds current player
			player = currentLevel.get_player()
			
			#position of slingshot rope relative to center
			var pullPositionGlobal = get_global_mouse_position()
			var pullPositionLocal = CenterOfSlingshot
			
			#length of pull
			var pullDistance = pullPositionGlobal.distance_to(CenterOfSlingshotGlobal)
			
			#direction of pull (unit vector)
			var pullDirection = (pullPositionGlobal - CenterOfSlingshotGlobal).normalized()
			var shootDirection = -pullDirection
			
			#shrinks pull distance and position if over max threshold
			if pullDistance > MaxSlingshotPull:
				pullDistance = MaxSlingshotPull
				pullPositionGlobal = CenterOfSlingshotGlobal + pullDirection * pullDistance
			
#			rabbit_just_moved_in_slingshot = not (prevPullPositionGlobal.distance_to(pullPositionGlobal) <= 0.1)
			rabbit_just_moved_in_slingshot = (prevPullPositionGlobal != pullPositionGlobal)
			prevPullPositionGlobal = pullPositionGlobal
			
			pullPositionLocal = pullPositionLocal + pullDirection * pullDistance
			
			#pullStrength is related to how far you pull the slingshot
			var pullStrength = pow(pullDistance / MaxSlingshotPull, 1)

			
			#velocity vector
			var speed = pullStrength * MaxLaunchVelocity
			velocity = shootDirection * speed * (1)

			$Arrow.global_position = pullPositionGlobal
			
			if right_just_pressed:
				print("cancelled throw")
				player.global_position = CenterOfSlingshotGlobal
				reset_slingshot()
				SlingshotState = SlingState.idle
				GhostTimer.stop()
				return
			
#			if Input.is_action_pressed("pull_in_slingshot"):
			if left_pressed:
				pass
				#makes slingshot rope follow player
				LeftLine.points[1] = pullPositionLocal
				RightLine.points[1] = pullPositionLocal
				player.global_position = pullPositionGlobal
				
				if rabbit_just_moved_in_slingshot:
					draw_trajectory(delta, pullPositionLocal, velocity)
					draw_trajectory_ghost()

			
			#happens right after rabbit is thrown
			else:
				throw_ghost()
				GhostTimer.stop()
#				if is_instance_valid(ghost):
#					ghost.queue_free()
					
				Manager.playAudio(launchNoise, -10)
				player.ThrowRabbit()
				lastRabbitThrown = player
				Manager.set_last_rabbit_thrown(player)
				player = player as RigidBody2D
				#player.position = CenterOfSlingshot
				#player.apply_impulse(Vector2(), velocity)
				#player.apply_central_impulse(velocity)
				player.linear_velocity = velocity
				player.angular_velocity = player.initial_angular_velocity
				
				player.showAbilitySelection(false)
				SlingshotState = SlingState.thrown
				currentLevel.CurrentGameState = currentLevel.GameState.Play
				reset_slingshot()
				
				#automatically reloads slingshot
#				yield(get_tree().create_timer(0.25), "timeout")
#				nextPlayer()
#				return_to_slingshot()

		SlingState.thrown:
			$CanvasLayer/RabbitControls.mouse_filter = Control.MOUSE_FILTER_PASS
#			if Input.is_action_just_pressed("ability"):
			if left_just_pressed:
				if is_instance_valid(player):
					player.useAbility()

			#if we want ability to be activated with double mouse click
#			if (Input.is_action_pressed("ability_1.2") and Input.is_action_just_pressed("ability_2.2")) or (Input.is_action_just_pressed("ability_1.2") and Input.is_action_pressed("ability_2.2")):
#				if is_instance_valid(player):
#					player.useAbility()
			
			#reloads slingshot on button press
#			if Input.is_action_pressed("return_to_slingshot"):
			if right_just_pressed:
				if get_tree().get_nodes_in_group("Player").size() <= 1:
					return
				nextPlayer()
				return_to_slingshot()


		SlingState.reset:
			$CanvasLayer/RabbitControls.mouse_filter = Control.MOUSE_FILTER_PASS
			var lives = get_tree().get_nodes_in_group("Player")
			
			if lives.size() >= 1:
				player = lives[0]
				#$Tween.interpolate_property(player, "global_position", player.position, CenterOfSlingshotGlobal, 0.1)
				#$Tween.start()
				movePlayerToSlingshot(0.1)
				if (player.global_position - CenterOfSlingshotGlobal).length() < 1: 
					SlingshotState = SlingState.idle
#			elif lives.size() == 0:
#				GameManager.gaveUp = true


func draw_trajectory_ghost():
	GhostTimer.start(ghost_time_to_launch)
	GhostDuplicate.visible = false
	yield(GhostTimer, "timeout")
	throw_ghost()


func throw_ghost():
	GhostDuplicate.mode = RigidBody2D.MODE_KINEMATIC
	GhostDuplicate.global_position = player.global_position
	GhostDuplicate.ThrowRabbit()
	GhostDuplicate.linear_velocity = velocity
	GhostDuplicate.angular_velocity = player.initial_angular_velocity
	GhostDuplicate.remove_from_group("Player")
	GhostDuplicate.remove_from_group("Rabbits")

	GhostDuplicate.showAbilitySelection(false)
	GhostDuplicate.modulate = Color(0.2, 0.2, 0.2, 0.5)
	GhostDuplicate.name = "Ghost"
	GhostDuplicate.visible = true

	if is_instance_valid(ghost):
		ghost.queue_free()
	ghost = get_tree().get_current_scene().add_child(GhostDuplicate)





#draws line as trajectory
func draw_trajectory(delta, pointPosition, velocity):
	var grav = ProjectSettings.get_setting("physics/2d/default_gravity")
	grav *= Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR).y
	if Input.is_action_just_pressed("return_to_slingshot"):
		SlingshotState = SlingState.idle
		reset_slingshot()
		player.global_position = CenterOfSlingshotGlobal
		return
	$ShotArc.clear_points()
	var c = 0.005
	var linear_damping = ProjectSettings.get_setting("physics/2d/default_linear_damp")
	for i in 500:
		$ShotArc.add_point(pointPosition)
		velocity *= (1.0 - delta * linear_damping)
		velocity.y += grav * delta / Engine.time_scale
		velocity += -c * velocity
		pointPosition += velocity * delta / Engine.time_scale
		if pointPosition.y  + global_position.y > 0 and velocity.y > 0:
			break



func reset_slingshot():
	#clears trajectory
	$ShotArc.clear_points()
	
	#returns rope to neutral position
	LeftLine.points[1] = CenterOfSlingshot
	RightLine.points[1] = CenterOfSlingshot
	

func return_to_slingshot():
#	if Manager.get_number_of_rabbits_left() <= 0:
#		return
	SlingshotState = SlingState.reset
	
	#var cams = get_tree().get_nodes_in_group("Cameras")
	#print(cams.size())
	
	#var currCam = cams[0]
	#currCam.resetCamera()
	

#finds next available character in line
func nextPlayer():
#	if Manager.get_number_of_rabbits_left() <= 0:
#		return
	#removes ability catchphrase if still up
	if is_instance_valid(player):
		player.hideCatchphrase()
		player.remove_from_group("Player")

	
	#resets camera
	if Manager.findCamera() != null:
		currentLevel.currentCamera.abilityZoomOut()
	if not Manager.slowmo:
		Manager.speedup()
		
	#finds next player
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		#player = GameManager.currentPlayer
		player = currentLevel.get_player()
		if player.has_node("Camera2D"):
			player.get_node("Camera2D").current = true

#moves next player into catapult
func movePlayerToSlingshot(t = 0.1):
	$Tween.interpolate_property(player, "global_position", player.global_position, CenterOfSlingshotGlobal, t)
	$Tween.start()

#when player presses on catapult to drag character
func _on_TouchArea_input_event(viewport, event, shape_idx):
#	print("1")
	if not can_start:
		return false

	if SlingshotState == SlingState.idle:
		if (event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT):
			SlingshotState = SlingState.pulling
			left_pressed = true
			left_just_pressed = true


func _on_RabbitControls_gui_input(event):
	
	if not (event is InputEventMouseButton):
		return
	
	var left_pressed_last_frame = left_pressed
	var right_pressed_last_frame = right_pressed
	
	left_pressed = (event is InputEventMouseButton) and (event.button_index == BUTTON_LEFT) and event.pressed
	right_pressed = (event is InputEventMouseButton) and (event.button_index == BUTTON_RIGHT) and event.pressed
	
	left_just_pressed = left_pressed and not left_pressed_last_frame
	right_just_pressed = right_pressed and not right_pressed_last_frame

#	print("right_just_pressed: ", right_just_pressed)
#	print("left_just_pressed: ", left_just_pressed)
#	print("right_pressed: ", right_pressed)
#	print("left_pressed: ", left_pressed)
