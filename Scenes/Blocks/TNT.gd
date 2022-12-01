extends Brick


const explosion = preload("res://Scenes/Effects/ExplosionTNT.tscn")

func _ready():
	angular_velocity = 10



func on_body_entered(body):
	var e = explosion.instance()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position
	
	queue_free()
