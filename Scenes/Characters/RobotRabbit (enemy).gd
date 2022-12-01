extends Bear



const explosion = preload("res://Scenes/Effects/ExplosionTNT.tscn")


func die():
	Manager.playAudio(deathNoise)
	
	var e = explosion.instance()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position
	
	queue_free()
