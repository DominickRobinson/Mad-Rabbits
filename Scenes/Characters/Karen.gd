extends Rabbit


export (float) var floatiness := 0.2

var og_gravity_scale = gravity_scale

func _ready():
	pass

#func _integrate_forces(state):
#	if $Gun.visible == true:
#		global_rotation = get_angle_to(get_global_mouse_position())

func ability1():
	$Gun.fire()
	rotation = get_angle_to(get_global_mouse_position())
	angular_velocity = 0
	angular_damp = 3
	ability_used = true
	#float
	gravity_scale = floatiness * og_gravity_scale
	self_modulate = Color.red

func stop_shooting():
	stop_floating()
	angular_damp = -1

func recoil():
	var dir = Vector2(cos(global_rotation), sin(global_rotation))
	#linear_velocity += -5*dir
	apply_central_impulse(-10*dir)

func stop_floating():
	gravity_scale = og_gravity_scale
