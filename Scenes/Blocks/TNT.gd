extends Brick


const explosion = preload("res://Scenes/Effects/ExplosionTNT.tscn")

func _ready():
	pass # Replace with function body.



func destroy_block():
	var e = explosion.instance()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position
	
	queue_free()
