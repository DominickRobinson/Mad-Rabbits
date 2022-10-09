extends Rabbit
const Explosion = preload("../Effects/Explosion.tscn")
const Kaboom = preload("../Effects/Kaboom.tscn")

func _ready2():
	catchphrase = "TRIPLE THREAT! HIYA!"


func ability():	
	explode()
	
	pass

func explode():
	var cloud = Explosion.instance()
	get_parent().add_child(cloud)
	cloud.position = global_position
	
	var flame = Kaboom.instance()
	get_parent().add_child(flame)
	flame.position = global_position
	
	print("kaboom")
	queue_free()
