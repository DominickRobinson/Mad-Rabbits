extends RigidBody2D
class_name Brick

export var max_health := 50
var health

var last_linear_velocity
var calculate_yet = true
var can_take_damage = false

onready var audio = $SoundEffect
onready var damageNoise = "res://Assets/Sound/Sound effects/ow.mp3"

func _init():
	#_ready2()
	
	health = max_health
	#health = 1000
	
	last_linear_velocity = linear_velocity
	can_take_damage = true
	contact_monitor = true
	contacts_reported = 1
	self.connect("body_entered", self, "on_body_entered")
	#print("brick")
#
#func _ready2():
#	pass


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
				damage += abs(body.linear_velocity.length())
			damage *= 0.1
			#print(damage)
			
			health -= damage
			Manager.Score += damage
			#print(health)
			if health <= 0:
				destroy_block()
				
				

func destroy_block():
	#print("block")
	queue_free()
