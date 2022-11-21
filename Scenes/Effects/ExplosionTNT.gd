extends Node2D


var power = 300
var exploding = true

func _ready():
	$Particles2D.emitting = true
	$Particles2D/Particles2D.emitting = true
	$Particles2D/Particles2D2.emitting = true
	$Particles2D/Particles2D3.emitting = true
	$AudioStreamPlayer.play()
	
	yield(get_tree().create_timer(0.1), "timeout")
	pushback()
	
	yield(get_tree().create_timer(2), "timeout")
	queue_free()


func pushback():
	for body in $Area2D.get_overlapping_bodies():
		if body is RigidBody2D:
			var dir = Vector2(1,0)
			var diff = body.global_position - self.global_position
			dir = dir.rotated(diff.angle())
			dir *= power
			
			body.apply_central_impulse(dir)
			
			if body.has_method("take_damage"):
				body.take_damage(40)
