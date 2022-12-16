extends Rabbit
const Explosion = preload("../Effects/Explosion.tscn")
const Kaboom = preload("../Effects/Kaboom.tscn")


export (float) var floatiness := 0.2



var og_gravity_scale = gravity_scale
var shoot_angle = null

func _ready():
	catchphrase_text = "d e s t r o y"
	$Sword.visible = false
	$Sword.disabled = true
	ability_slowmo_scale = 0.9
	zoom_in_duration = 1.55



#sword
func ability1():
	$Sword.visible = true
	$Sword.disabled = false

	

func explode():
	var cloud = Explosion.instance()
	get_parent().add_child(cloud)
	cloud.position = global_position
	
	var flame = Kaboom.instance()
	get_parent().add_child(flame)
	flame.position = global_position
	
	#print("kaboom")
	
	sayCatchphrase()
	if self == Manager.last_rabbit_thrown():
		showCatchphrase()
	if counter == 0:
		ability_used = true
	
	yield(get_tree().create_timer(0.4), "timeout")
	if not Manager.slowmo:
		Manager.speedup()
	hideCatchphrase()
	Manager.findCamera().abilityZoomOut()
	queue_free()



func stop_shooting():
	#print("anim done")
	stop_floating()
	angular_damp = -1
	linear_damp = -1

func recoil():
	var dir = Vector2(cos(global_rotation), sin(global_rotation))
	#linear_velocity += -5*dir
	apply_central_impulse(-2*dir)

func stop_floating():
	gravity_scale = og_gravity_scale
