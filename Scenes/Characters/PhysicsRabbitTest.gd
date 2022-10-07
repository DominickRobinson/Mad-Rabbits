extends Node2D
class_name RabbitTest


export var DespawnTimer := 2
export var DespawnVelocity := 5

export var initial_angular_velocity := 3
export var ability_used := false

export var catchphrase_text := "IT'S MORBIN' TIME!!"
#export(String, FILE, ".mp3") var catchphrase_filename := ""
export var catchphrase_filename := ""

onready var catchphrase = $CatchphraseAudio

var dying = false
var deathCounter = 0
var dead = false

var c = 0.005

enum RabbitState {
	notThrown,	
	thrown
}

var state = RabbitState.notThrown


func _ready():
	$Body.contact_monitor = true
	$Body.contacts_reported = 1
	$Body.mode = RigidBody2D.MODE_KINEMATIC
	#mode = RigidBody2D.MODE_RIGID
	catchphrase.connect("finished", self, "_on_Catchphrase_finished")
	connect("body_entered", $Body, "collide_with_rabbit")
	prepareAbilityPopup()
	_ready2()

func _ready2():
	pass


func _physics_process(delta):
	
	match state:
		RabbitState.thrown:
			
			$Body.linear_velocity += -c * linear_velocity
			
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
			#state = RabbitState.notThrown
			
	if dead:
		#print("ded XD")
		pass


func ThrowRabbit():
	mode = RigidBody2D.MODE_RIGID
	state = RabbitState.thrown

func despawnConditionsMet():
	return true
	
	var despawn = false
	despawn = linear_velocity <= Vector2(1, 1) * DespawnVelocity
	
	return despawn


func useAbility():
	if ability_used:
		return false
	ability()
	sayCatchphrase()
	ability_used = true



func ability():
	#print("no special ability :(")
	if is_instance_valid($AbilityPanel/Control):
		print("success")
		#$AbilityPanel/Control.visible = true
	else:
		print("failed")
	ability_used = true


func sayCatchphrase():
	print(catchphrase_text)
	if catchphrase_filename != "":
		catchphrase.stream = load(catchphrase_filename)
		catchphrase.play()
	if is_instance_valid($AbilityPanel/Control):
		$AbilityPanel/Control.visible = true


func _on_Catchphrase_finished():
	#catchphrase.stop()
	#print("catchphrase done")
	if is_instance_valid($AbilityPanel/Control):
		$AbilityPanel/Control.visible = false
	pass

func prepareAbilityPopup():
	if is_instance_valid($AbilityPanel):
		#$AbilityPanel/Control.visible = false
		#$AbilityPanel/Control/DialoguePanel/Catchphrase.bbcode_text = catchphrase_text
		pass
	pass


func collide_with_rabbit(body):
	if ability_used:
		return false
	
	if is_instance_valid(body):
		if body.is_in_group("Rabbits") and body.state == RabbitState.thrown:
			if not ability_used and state == RabbitState.thrown:
				ability()
