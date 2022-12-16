extends Character
class_name Bear


var rng = RandomNumberGenerator.new()

export var health := 300

var last_linear_velocity
var calculate_yet = true
var can_take_damage = false
const Kaboom = preload("../Effects/Kaboom.tscn")

var random_generator = RandomNumberGenerator.new()

#var deathNoise = "res://Assets/Sound/SoundEffects/dying.mp3"
export(String, FILE) var oofNoise1 := "res://Assets/Sound/SoundEffects/oof.mp3"
export(String, FILE) var oofNoise2 := "res://Assets/Sound/SoundEffects/ow.mp3"
export (String, FILE) var deathNoise := "res://Assets/Sound/SoundEffects/wilhelmscream.mp3"

func _ready():
	last_linear_velocity = linear_velocity
	yield(self,"ready")
	activate()

func activate():
	yield(get_tree().create_timer(1.0), "timeout")
#	print(self.name, " is ready!")
	can_take_damage = true
	contact_monitor = true
	contacts_reported = 1
	self.connect("body_entered", self, "_on_body_entered")


func _process(delta):
	#print(calculate_yet)
	calculate_linear_velocity()


func calculate_linear_velocity():
	
	if calculate_yet:
		calculate_yet = false
		last_linear_velocity = linear_velocity
		#print(last_linear_velocity)
		var t = Timer.new()
		t.set_wait_time(0.1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		calculate_yet = true


func _on_AnimatedSprite_animation_finished():
	rng.randomize()
	var my_random_number = rng.randf_range(-1.0, 10000.0)
	
	if my_random_number >= 0:
		$AnimatedSprite.modulate = Color(1, 1, 1)
		$AnimatedSprite.animation = "good"
	else:
		$AnimatedSprite.modulate = Color(1, 0, 0)
		$AnimatedSprite.animation = "bad"


func _on_body_entered(body):
	
	if not can_take_damage:
		return false
	#print(body)
	if is_instance_valid(body):
		if body is RigidBody2D or body.is_in_group("Rabbits"):
			#if body.is_in_group("Player"):
			#	queue_free()
			#else:
			
			var damage = (body.linear_velocity*body.mass).distance_to(last_linear_velocity)
			#damage *= 0.1
			take_damage(damage)

				
		elif body is StaticBody2D:
			var damage = abs(last_linear_velocity.length()) * 0.1
			take_damage(damage)


func take_damage(amt):
	amt = int(amt)
	if amt <= 5:
		return
	Manager.makePOW(get_tree().get_root(), str(int(amt)), Color(1, 1, 1, 0.5), global_position, 25)

	random_generator.randomize()
	var random_value = random_generator.randi_range(0,1)
	match random_value:
		0:
			Manager.playAudio(oofNoise1, 20)
		1:
			Manager.playAudio(oofNoise2, 10)
	
	health -= amt
#	print("Damage: ", amt)
#	print("Health remaining: ", health)
	if health <= 0:
		die()

func die():
#	print("die")
	Manager.playAudio(deathNoise)
	queue_free()
