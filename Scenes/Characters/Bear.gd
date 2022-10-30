extends Character


var rng = RandomNumberGenerator.new()

export var health := 300

var last_linear_velocity
var calculate_yet = true
var can_take_damage = false
const Kaboom = preload("../Effects/Kaboom.tscn")

#var deathNoise = "res://Assets/Sound/Sound effects/dying.mp3"
var deathNoise = "res://Assets/Sound/Sound effects/wilhelmscream.mp3"

func _ready():
	last_linear_velocity = linear_velocity
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	contact_monitor = true
	can_take_damage = true
	#calculate_yet = true


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


func _on_HurtZone_body_entered(body):
	
	if not can_take_damage:
		return false
	#print(body)
	if is_instance_valid(body):
		if body is RigidBody2D or body.is_in_group("Rabbits"):
			#if body.is_in_group("Player"):
			#	queue_free()
			#else:
			Manager.makePOW(get_tree().get_root(), "dab", Color(0, 1, 0, 0.5), global_position, 25)
			
			var damage = abs(body.linear_velocity.length()) + abs(last_linear_velocity.length())
			#damage *= 0.1
			#print(damage)
			
			health -= damage
			Manager.Score += damage
			#print(health)
			if health <= 0:
				Manager.playAudio(deathNoise)
				queue_free()
				
		elif body is TileMap:
			var damage = abs(last_linear_velocity.length()) * 0.1
			health -= damage
			Manager.Score += damage
			#print(health)
			if health <= 0:
				queue_free()
				pass # Replace with function body.
		elif body.is_in_group("Explosion"):
			var cloud = Kaboom.instance()
			get_parent().add_child(cloud)
			cloud.position = global_position
			queue_free()

