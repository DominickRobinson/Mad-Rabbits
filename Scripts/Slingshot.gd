extends Node2D

enum SlingState {
	idle,
	pulling,
	thrown,
	reset	
}

export var MaxSlingshotPull := 100
export var MaxLaunchVelocity := 400

var SlingshotState
var LeftLine
var RightLine
var CenterOfSlingshot
var CenterOfSlingshotGlobal
var player

var can_start = false

var music = "res://Assets/Sound/Music/Symphony-no.-40-in-G-minor-K.-550-I.-Molto-Allegro.mp3"
var launchNoise = "res://Assets/Sound/Sound effects/slingshot.mp3"

func _ready():
	
	GameManager.playAudio(music, -12, false)
	
	SlingshotState = SlingState.idle
	LeftLine = $LeftLine
	RightLine = $RightLine
	CenterOfSlingshot = $CenterOfSlingshot.position
	CenterOfSlingshotGlobal = $CenterOfSlingshot.global_position
	player = GameManager.findPlayer()
	reset_slingshot()
	
	wait(1)
	#$Tween.interpolate_property(player, "global_position", player.global_position, CenterOfSlingshotGlobal, 1)
	#$Tween.start()
	movePlayerToSlingshot(1)
	

	print(str(player.position))
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
	
	#print(str(SlingState.pulling))
	#print(CenterOfSlingshotGlobal)
	#print(player.global_position)
	
	match SlingshotState:
		SlingState.idle:
			pass
		SlingState.pulling:
			#finds player
			
			if not can_start:
				return false
			
			player = GameManager.currentPlayer
			#position of slingshot rope relative to center
			var pullPositionGlobal = get_global_mouse_position()
			var pullPositionLocal = CenterOfSlingshot
			#length of pull
			var pullDistance = pullPositionGlobal.distance_to(CenterOfSlingshotGlobal)        ####
			#direction of pull (unit vector)
			var pullDirection = (pullPositionGlobal - CenterOfSlingshotGlobal).normalized()   ####
			var shootDirection = -pullDirection
			
			#$Arrow.rotation = pullDirection.angle() + PI/4 
			
			#shrinks pull distance and position if over max threshold
			if pullDistance > MaxSlingshotPull:
				pullDistance = MaxSlingshotPull
				pullPositionGlobal = CenterOfSlingshotGlobal + pullDirection * pullDistance   ####
			
			#print(rad2deg(pullDirection.angle()))
			pullPositionLocal = pullPositionLocal + pullDirection * pullDistance
			#pullStrength is related to how far you pull the slingshot
			var pullStrength = pow(pullDistance / MaxSlingshotPull, 2)
			#var pullStrength = sqrt(pullDistance / MaxSlingshotPull)
			#print(pullStrength)
			
			#velocity vector
			var speed = pullStrength * MaxLaunchVelocity
			var velocity = shootDirection * speed * (1)
			#print(velocity)
			#velocity.x *= -1
			#velocity.y *= -1
			
			$Arrow.global_position = pullPositionGlobal
			
			if Input.is_action_pressed("Left_Mouse"):
				LeftLine.points[1] = pullPositionLocal
				RightLine.points[1] = pullPositionLocal
				player.global_position = pullPositionGlobal
				var pointPosition = pullPositionLocal
				var grav = ProjectSettings.get_setting("physics/2d/default_gravity")
				$ShotArc.clear_points()
				var c = 0.005
				for i in 500:
					$ShotArc.add_point(pointPosition)
					velocity.y += grav * delta
					velocity += -c * velocity
					pointPosition += velocity * delta
					if pointPosition.y > $ShotArc.position.y:
						#print(str(i))
						break
			else:
				GameManager.playAudio(launchNoise, -10)
				player.ThrowRabbit()
				player = player as RigidBody2D
				#player.position = CenterOfSlingshot
				#player.apply_impulse(Vector2(), velocity)
				#player.apply_central_impulse(velocity)
				player.linear_velocity = velocity
				player.angular_velocity = player.initial_angular_velocity
				
				SlingshotState = SlingState.thrown
				GameManager.CurrentGameState = GameManager.GameState.Play
				
				get_tree().get_nodes_in_group("Camera")[0].followingPlayer = true
				
		SlingState.thrown:
			if Input.is_action_just_pressed("ability"):
				if is_instance_valid(player):
					player.useAbility()
			

			
			if Input.is_action_pressed("return_to_slingshot"):
				nextPlayer()
				return_to_slingshot()

		SlingState.reset:
			var lives = get_tree().get_nodes_in_group("Player")
			reset_slingshot()
			if lives.size() > 0:
				player = lives[0]
				#$Tween.interpolate_property(player, "global_position", player.position, CenterOfSlingshotGlobal, 0.1)
				#$Tween.start()
				movePlayerToSlingshot(0.1)
				if (player.global_position - CenterOfSlingshotGlobal).length() < 1: 
					SlingshotState = SlingState.idle
			elif lives.size() == 0:
				GameManager.gaveUp = true


func reset_slingshot():
	$ShotArc.clear_points()
	LeftLine.points[1] = CenterOfSlingshot
	RightLine.points[1] = CenterOfSlingshot
	

func return_to_slingshot():
	
	SlingshotState = SlingState.reset
	
	var cams = get_tree().get_nodes_in_group("Cameras")
	#print(cams.size())
	
	var currCam = cams[0]
	currCam.resetCamera()
	


func nextPlayer():
	if is_instance_valid(player):
		player.remove_from_group("Player")
	var players = get_tree().get_nodes_in_group("Player")
	
	print("All remaining rabbits:")
	print(str(players))
	
	if players.size() > 0:
		player = GameManager.currentPlayer

func movePlayerToSlingshot(t = 0.1):
	$Tween.interpolate_property(player, "global_position", player.global_position, CenterOfSlingshotGlobal, t)
	$Tween.start()

func _on_TouchArea_input_event(viewport, event, shape_idx):
	
	if not can_start:
		return false
	
	if SlingshotState == SlingState.idle:
		if (event is InputEventMouseButton and event.pressed):
			SlingshotState = SlingState.pulling
