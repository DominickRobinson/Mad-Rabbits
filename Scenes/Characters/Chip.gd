extends Rabbit


var big = false
export var big_bounces := 10
export var big_bounce_vel_scale := 1.3

export var rainbow := false

onready var RainbowShader = preload("res://Assets/Shaders/rainbow.tres")


func _ready():
	catchphrase_text = "OOGA BOOGA"
	$LargeBody.visible = false
	$LargeBody.disabled = true
	#connect("body_shape_entered", self, "bounce")

	if rainbow:
		var sprites = get_all_sprites($Body)
		for s in sprites:
			if s.name == "Halo":
				break
			s.material = ShaderMaterial.new()
			s.material.shader = RainbowShader


func ability1():
	make_big()
	self.modulate = Color.red
	ability_used = true


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


func get_all_sprites(in_node,arr:=[]):
	#print("Currently checking: ", in_node, ". Here are its children: ", in_node.get_children())
	for child in in_node.get_children():
		arr = get_all_sprites(child,arr)
	if in_node is Sprite and in_node.get_name() != "Foot":
		#(in_node.get_name(), " is a Sprite!!!")
		arr.push_back(in_node)
	return arr
