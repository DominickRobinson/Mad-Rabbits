extends RigidBody2D
class_name Brick

export var max_health := 50
var health

var last_linear_velocity
var calculate_yet = true
var can_take_damage = false

var random_generator = RandomNumberGenerator.new()

#export(String, FILE) var hit_noise_filename := "res://Assets/Sound/SoundEffects/pow.mp3"
var hit_noise1_filename := "res://Assets/Sound/SoundEffects/hit.mp3"
var hit_noise2_filename := "res://Assets/Sound/SoundEffects/ow.mp3"


onready var audio = $SoundEffect
onready var damageNoise = "res://Assets/Sound/SoundEffects/ow.mp3"

func _init():
	#_ready2()
	
	health = max_health
	#health = 1000
	
	last_linear_velocity = linear_velocity
	yield(self,"ready")
	activate()
	#print("brick")
#
#func _ready2():
#	pass

func activate():
	yield(get_tree().create_timer(1.0), "timeout")
#	print(self.name, " is ready!")
	can_take_damage = true
	contact_monitor = true
	contacts_reported = 6
	self.connect("body_entered", self, "on_body_entered")
	

func _process(delta):
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



func on_body_entered(body):
#	print("hit")
	if not can_take_damage:
		return false
	#print(body)
	if is_instance_valid(body):
		if body is RigidBody2D or body is StaticBody2D or body.is_in_group("Rabbits"):
			#if body.is_in_group("Player"):
			#	queue_free()
			#else:
			#Manager.makePOW(get_tree().get_root(), "dab", Color(0, 1, 0, 0.5), global_position, 25)
			
			var damage = abs(last_linear_velocity.length())
			if not (body is StaticBody2D):
				damage = (body.linear_velocity*body.mass).distance_to(last_linear_velocity)
			damage *= 0.1
			#print(damage)
			
			take_damage(damage)
				

func take_damage(amt):
	amt = int(amt)
	if amt <= 5:
		return
	
#	Manager.makePOW(self, str(amt), Color(0, 1, 0, 0.5), global_position, 25)
	random_generator.randomize()
	var random_value = random_generator.randi_range(0,1)
	match random_value:
		0:
			Manager.playAudio(hit_noise1_filename, 7)
		1:
			Manager.playAudio(hit_noise2_filename, 0)
		
	health -= amt
	Manager.Score += amt
	#print(health)
	if health <= 0:
		destroy_block()


func destroy_block():
	#print("block")
	queue_free()
