extends RigidBody2D

const explosion = preload("res://Scenes/Effects/ExplosionTNT.tscn")


func _ready():
	angular_velocity = 10


func _on_Egg_body_entered(body):
	var e = explosion.instance()
	e.global_position = global_position
	get_tree().get_current_scene().add_child(e)
	
	queue_free()
