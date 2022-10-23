extends Rabbit
const Explosion = preload("../Effects/Explosion.tscn")
const Kaboom = preload("../Effects/Kaboom.tscn")

func _ready():
	catchphrase_text = "d e s t r o y"


func ability():
	ability_used = true
	explode()
	

func explode():
	var cloud = Explosion.instance()
	get_parent().add_child(cloud)
	cloud.position = global_position
	
	var flame = Kaboom.instance()
	get_parent().add_child(flame)
	flame.position = global_position
	
	print("kaboom")
	
	sayCatchphrase()
	if self == GameManager.last_rabbit_thrown():
		showCatchphrase()
	if counter == 0:
		ability_used = true
	
	yield(get_tree().create_timer(0.4), "timeout")
	if not GameManager.slowmo:
		GameManager.speedup()
	hideCatchphrase()
	GameManager.currentCamera.abilityZoomOut()
	queue_free()
