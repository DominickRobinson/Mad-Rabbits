extends Rabbit


export (float) var floatiness := 0.2

var og_gravity_scale = gravity_scale
var shoot_angle = null

func _ready():
	pass

#func _integrate_forces(state):
#	if $Gun.visible == true:
#		global_rotation = get_angle_to(get_global_mouse_position())

func _unhandled_input(event):
	if Input.is_action_just_pressed("ability"):
		shoot_angle = rad2deg(get_global_mouse_position().angle_to_point(global_position))
		print(shoot_angle)

func ability1():
	$Gun.fire()
	angular_velocity = 0
	var temp_lin_vel = linear_velocity
	linear_velocity *= 0
	linear_damp = 10
	

	freeze()
	if shoot_angle != null:
		global_rotation_degrees = shoot_angle
		print("shooting at: ", shoot_angle)
	angular_damp = 10
	
	ability_used = true
	gravity_scale = floatiness * og_gravity_scale
	self_modulate = Color.red
	
	yield(get_tree().create_timer(zoom_in_duration), "timeout")
	unfreeze()
	stop_shooting()
	linear_velocity = temp_lin_vel

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
