extends Rabbit
#const Explosion = preload("../Effects/Explosion.tscn")
#const Kaboom = preload("../Effects/Kaboom.tscn")
const Explosion = preload("res://Scenes/Effects/ExplosionTNT.tscn")

export (float) var floatiness := 0.2
export var show_infinity_carrot := false


var og_gravity_scale = gravity_scale
var shoot_angle = null

func _ready():
	catchphrase_text = "d e s t r o y"
	$Sword.visible = false
	$Sword.disabled = true
	ability_slowmo_scale = 0.9
	zoom_in_duration = 1.55
	
	if show_infinity_carrot:
		get_node("Infinity Carrot").visible = true
	else:
		get_node("Infinity Carrot").visible = false


#glock
func ability1():
	$Gun.fire()
	angular_velocity = 0
	var temp_lin_vel = linear_velocity
	linear_velocity *= 0
	linear_damp = 10

	freeze()
	if shoot_angle != null:
		global_rotation_degrees = shoot_angle
	angular_damp = 10
	
	ability_used = true
	gravity_scale = floatiness * og_gravity_scale
	self_modulate = Color.red
	
	yield(get_tree().create_timer(zoom_in_duration), "timeout")
	unfreeze()
	stop_shooting()
	#linear_velocity = temp_lin_vel



#lightsaber
func ability2():
	$Sword.visible = true
	$Sword.disabled = false


#explosion
func ability3():
	ability_used = true
	explode()
	

func explode():
#	var cloud = Explosion.instance()
#	get_parent().add_child(cloud)
#	cloud.position = global_position
#
#	var flame = Kaboom.instance()
#	get_parent().add_child(flame)
#	flame.position = global_position
	
	var e = Explosion.instance()
	get_tree().current_scene.add_child(e)
	e.global_position = global_position
	e.scale = Vector2(6,6)
	e.power = 500
	
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
