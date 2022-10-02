extends Rabbit
const Explosion = preload("../Effects/Explosion.tscn")


func _ready2():
	catchphrase = "TRIPLE THREAT! HIYA!"


func ability():
	
	
	explode()
	
	pass

func explode():
	var cloud = Explosion.instance()
	get_parent().add_child(cloud)
	print(global_position)
	cloud.position = global_position
	print("kaboom")
