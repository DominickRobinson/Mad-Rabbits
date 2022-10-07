extends RigidBody2D
class_name Brick

export var max_health := 100
var health

var last_linear_velocity
var calculate_yet = true
var can_take_damage = false

func _ready():
	_ready2()
	
	health = max_health
	
	last_linear_velocity = linear_velocity
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	can_take_damage = true
	contact_monitor = true

func _ready2():
	pass


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


func _on_Brick_body_entered(body):
	#print("body entered :0")
	if is_instance_valid(body):
		if body is RigidBody2D:
			
			if not can_take_damage:
				return false
			
			#print(health)
			body = body as RigidBody2D
			#var damage = body.linear_velocity.length()
			var damage = abs(body.mass * body.linear_velocity.length()) + abs(last_linear_velocity.length())
			print(damage)
			health -= damage
			
#			if is_instance_valid($Bubble):
#				#print("bubble!")
#				$Bubble.activate()
			
			if health <= 0:
				#body's linear velocity will slow significantly if it just barely destroys a block
				#body.linear_velocity *= 1 - abs(damage + health) / abs(damage)
				queue_free()


func _on_body_entered():
	pass # Replace with function body.
