extends Rabbit

export (int) var speedboost := 6
export (float) var speedcrash := -.25
export (float) var chain_pull := 105

export (float) var kickSpin := 40

onready var MotionBlurShader = preload("res://Assets/Shaders/motion_blur.tres")
const explosion = preload("res://Scenes/Effects/ExplosionTNT.tscn")
onready var Smoke = preload("res://Scenes/Effects/GunSmoke.tscn")

var blur = false
var sprites : Array

var teleport_global_position = null
var should_teleport = false

func _ready():
	zoom_in = {1: true, 2: true, 3: false}
	catchphrase_text = "TRIPLE THREAT! HIYA!"
	#adds shader to all sprites
	sprites = get_all_sprites($Body)
	#print("Sprites: ", sprites)
	for s in sprites:
		s.material = ShaderMaterial.new()
		s.material.shader = MotionBlurShader
		
	#print("Sprites", sprites)
	#will stop blurring once rabbit collides with something

func _unhandled_input(event):
	if Input.is_action_just_pressed("ability"):
		teleport_global_position = get_global_mouse_position()
		#print(shoot_angle)



func _physics_process(delta):
	if blur:
		blur()
#	if $Chain.hooked:
#		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
#		var chain_velocity = ($Chain.tip.position - position).normalized() * chain_pull
#		chain_velocity = chain_velocity.rotated(PI / 2)
#		set_axis_velocity(chain_velocity)

#split into 3
func ability1():
	var copy = load(self.filename)
	newNinja(Vector2(-20, 0), Color(0, 1, 0), 1.5)
	newNinja(Vector2(20, 0), Color(0, 0, 1), 1.5)
	self.modulate = Color(1, 0, 0)
	ability_used = true
	#change


#ninja kick!
func ability2():
	connect("body_entered", self, "stop_blur")
	$Foot.visible = true
	angular_velocity = 0
	modulate = Color(1,0,0)
	var speed = linear_velocity.length()
	linear_velocity = speedboost * Vector2(speed, 0).rotated(rotation)
	ability_used = true
	blur()
	self.modulate = Color.red


#teleport
func ability3():
#	should_teleport = true
	make_explosion(1, 1.5)
	var c = load(self.filename)
	var copy = c.instance()
	self.get_parent().add_child(copy)
	self.get_parent().move_child(copy, 0)
	Manager.set_last_rabbit_thrown(copy)
	copy = copy as Rabbit
	copy.ThrowRabbit()
	copy.global_position = teleport_global_position
	copy.linear_velocity = linear_velocity
	copy.angular_velocity = angular_velocity
	copy.ability_used = true
	copy.modulate = modulate
	copy.remove_from_group("Player")
	copy.shoot_smoke(1)
	copy.shoot_smoke(1.5)
	queue_free()

#func ability3():
##	$Chain.visible = true
##	$Chain.shoot(get_viewport().get_mouse_position() - get_viewport().size * 0.5)
#	pass


func ThrowRabbit():
	mode = RigidBody2D.MODE_RIGID
	state = RabbitState.thrown
	showAbilitySelection(false)
	if currentAbility == 2:
		initial_angular_velocity = kickSpin


func newNinja(offset, color, vel_mult):
	var dup = load(self.filename)
	var copy = dup.instance()
	self.get_parent().add_child(copy)
	copy = copy as Rabbit
	copy.ThrowRabbit()
	var lv_dir = linear_velocity.angle()
	copy.global_position = global_position + offset.rotated(lv_dir + PI/2)
	copy.linear_velocity = (linear_velocity + offset) * vel_mult
	copy.angular_velocity = angular_velocity * vel_mult
	copy.ability_used = true
	copy.modulate = color
	copy.remove_from_group("Player")
	
	
	
func blur():
	blur = true
	for s in sprites:
		var dir = linear_velocity.angle() - rotation
		#dir  = rotation - dir
		var shaderDir = Vector2(cos(dir), sin(dir))
		s.get_material().set_shader_param("dir", shaderDir/2)

func stop_blur(body):
	#stops blurring
	blur = false
	for s in sprites:
		s.get_material().set_shader_param("dir", Vector2(0,0))
	#shrinks velocity
	linear_velocity *= speedcrash
	$Foot.visible = false
	disconnect("body_entered", self, "stop_blur")

func make_explosion(s,s2):
	var e = explosion.instance()
	e.global_position = global_position
	e.scale *= s
	get_tree().get_current_scene().add_child(e)
	shoot_smoke(s2)
	shoot_smoke(s2*1.5)


func shoot_smoke(s):
	var smoke = Smoke.instance()
	smoke.scale *= s
	smoke.global_position = global_position
	smoke.emitting = true
	get_tree().get_current_scene().add_child(smoke)
