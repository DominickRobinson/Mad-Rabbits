extends Rabbit


var big = false
var blur = false
export var big_bounces := 10
export var big_bounce_vel_scale := 1.3

export (int) var speedboost := 1000
export (float) var speedcrash := -.25

export var rainbow := false

onready var RainbowShader = preload("res://Assets/Shaders/rainbow.tres")
onready var MotionBlurShader = preload("res://Assets/Shaders/motion_blur.tres")
onready var Egg = preload("res://Scenes/Egg.tscn")

var sprites : Array

func _ready():
	catchphrase_text = "OOGA BOOGA"
	$LargeBody.visible = false
	$LargeBody.disabled = true
	#connect("body_shape_entered", self, "bounce")

	sprites = get_all_sprites($Body)

	if rainbow:
		for s in sprites:
			if s.name == "Halo":
				break
			s.material = ShaderMaterial.new()
			s.material.shader = RainbowShader


func _physics_process(delta):
	if blur:
		blur()


#get big
func ability1():
	make_big()
	self.modulate = Color.red
	ability_used = true


#ground pound
func ability2():
	
	for s in sprites:
			if s.name == "Halo":
				break
			s.modulate = Color.red
			s.material = ShaderMaterial.new()
			s.material.shader = MotionBlurShader
			
	connect("body_entered", self, "stop_blur")
	angular_velocity = 0
	rotation = 0
	linear_velocity = Vector2(0, speedboost)
	ability_used = true
	blur()


#egg drop
func ability3():
	ability_used = true
	for s in sprites:
		s.modulate = Color.red
	var e = Egg.instance()
	e.global_position = global_position + Vector2(0, 25)
	e.linear_velocity = Vector2(0, 0)
	get_tree().get_current_scene().add_child(e)
	self.linear_velocity.y -= 200


func make_big():
	$Body.visible = false
	$Body.set_deferred("disabled", true)
	$LargeBody.visible = true
	$LargeBody.set_deferred("disabled", false)
	set_bounce(1)
	mass = 4
	contact_monitor = true
	contacts_reported = 2
	big = true

func make_small():
	$LargeBody.visible = false
	$LargeBody.set_deferred("disabled", true)
	$Body.visible = true
	$Body.set_deferred("disabled", false)
	set_bounce(0.2)
	mass = 1
	contact_monitor = false
	contacts_reported = 0
	big = false


func _bounce(body):
	if big:
		big_bounces -= 1
		linear_velocity *= big_bounce_vel_scale
		if big_bounces == 0:
			make_small()

func blur():
	if rainbow:
		return
	blur = true
	for s in sprites:
		var dir = linear_velocity.angle()
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
