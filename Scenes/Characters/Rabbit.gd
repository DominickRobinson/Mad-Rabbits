extends Character
class_name Rabbit

export var DespawnTimer := 2
export var DespawnVelocity := 5

export var initial_angular_velocity := 3
export var ability_used := false

export var catchphrase_text := "*insert catchphrase text here*"


export var counter := 4
export (int) var totalAbilities := 1

export (float) var ability_slowmo_scale := 0.2
export (float) var zoom_in_duration := 0.4

export(String, FILE) var catchphrase1_filename := ""
export(String, FILE) var catchphrase2_filename := ""
export(String, FILE) var catchphrase3_filename := ""


#different abilities
var currentAbility = 1

var teamwork_file = "res://Assets/Sound/SoundEffects/teamwork.mp3"

var zoom_in = {1: true, 2: true, 3: true}

var dying = false
var deathCounter = 0
var dead = false

var c = 0.005

enum RabbitState {
	notThrown,	
	thrown
}

var state = RabbitState.notThrown


func _init():
	contact_monitor = true
	contacts_reported = 1
	mode = RigidBody2D.MODE_KINEMATIC

	connect("body_entered", self, "collide_with_rabbit")
	prepareAbilityPopup()
	
	if totalAbilities == 0:
		if is_instance_valid($AbilitySelectionPanel):
			$AbilitySelectionPanel.visible = false


func _physics_process(delta):
	#print(angular_velocity)
	clamp(angular_velocity, -150, 150)
	if not Options.abilityCatchphraseVisible:
		if is_instance_valid($AbilityPanel/Control):
			$AbilityPanel/Control.visible = false
		
	match state:
		RabbitState.thrown:
			
			linear_velocity += -c * linear_velocity * Engine.time_scale
			
			if despawnConditionsMet() and not dying:
				var dying = true
				var t = Timer.new()
				t.set_wait_time(DespawnTimer)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				#queue_free()
				dead = true


func ThrowRabbit():
	mode = RigidBody2D.MODE_RIGID
	state = RabbitState.thrown
	showAbilitySelection(false)


func despawnConditionsMet():
	return true
	
	var despawn = false
	despawn = linear_velocity <= Vector2(1, 1) * DespawnVelocity
	
	return despawn


func useAbility():

	if totalAbilities == 0:
		return
	#dont use if ability already used
	if ability_used:
		return false
	
	#dramatic zoom in
	if Options.zoomInDuringAbility and zoom_in[currentAbility] == true and Manager.findCamera() != null:
		Manager.findCamera().abilityZoomIn()
		yield(Manager.findCamera().posTween, "tween_completed")
#		yield(Manager.findCamera().zoomTween, "tween_completed")
		Manager.slowdown(ability_slowmo_scale)

	#ability
	ability()

	#show catchphrase if on in settings
	if Options.abilityCatchphraseVisible:
		showCatchphrase()
	
	#says catchphrase
	sayCatchphrase()
	
	#checks if ability cant be used again
	if counter == 0:
		ability_used = true
	
#	modulate = Color(1,0,0)
	
	#dramatic zoom out
	yield(get_tree().create_timer(zoom_in_duration), "timeout")
	if not Manager.slowmo:
		Manager.speedup()
	else:
		Manager.slowdown()
	if Options.zoomInDuringAbility and Manager.findCamera() != null:
		Manager.get_level().get_camera().abilityZoomOut()
	hideCatchphrase()



func ability1():
	pass

func ability2():
	pass

func ability3():
	pass

func set_ability(num):
	currentAbility = num

func ability():
	if totalAbilities == 0:
		return
	match currentAbility:
		1:	ability1()
		2:	ability2()
		3:	ability3()
	
	ability_used = true
	#self.modulate = Color.red


func sayCatchphrase():
	match currentAbility:
		1:
			Manager.playAudio(catchphrase1_filename, 10)
		2:
			Manager.playAudio(catchphrase2_filename, 10)
		3:
			Manager.playAudio(catchphrase3_filename, 10)


func showCatchphrase():
	if is_instance_valid($AbilityPanel/Control):
		$AbilityPanel/Control.visible = true

func hideCatchphrase():
	if is_instance_valid($AbilityPanel/Control):
		$AbilityPanel/Control.visible = false
		
#	print(catchphrase_text)
#	if catchphrase_filename != "":
#		catchphrase.stream = load(catchphrase_filename)
#	catchphrase.play()
#	if is_instance_valid($AbilityPanel/Control):
#		$AbilityPanel/Control.visible = true


#func _on_Catchphrase_finished():
#	#catchphrase.stop()
#	#print("catchphrase done")
#	if is_instance_valid($AbilityPanel/Control):
#		$AbilityPanel/Control.visible = false
#	pass

func prepareAbilityPopup():
	if is_instance_valid(get_node("AbilityPanel")):
		$AbilityPanel/Control.visible = false
		$AbilityPanel/Control/DialoguePanel/Catchphrase.bbcode_text = catchphrase_text

func showAbilitySelection(show):
	if is_instance_valid($AbilitySelectionPanel):
		$AbilitySelectionPanel.toggle_visibility(show)


func collide_with_rabbit(body):
	if ability_used:
		return false
	
	if is_instance_valid(body):
		
		if body.is_in_group("Rabbits") and body.state == RabbitState.thrown:
			if not ability_used and state == RabbitState.thrown:
				Manager.playAudio(teamwork_file, -15)
				
				ability()
				
#				if linear_velocity.length() > body.linear_velocity.length():
#					useAbility()
#				else:
#					ability()
				
#				if self == GameManager.last_rabbit_thrown():
#					useAbility()
#				else:
#					ability()
		
				#make collisions more volatile
				linear_velocity *= 2





