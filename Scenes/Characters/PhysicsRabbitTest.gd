extends Rabbit


export (int) var speedboost := 6
export (float) var speedcrash := -.25
export (int) var totalAbilities := 1

onready var MotionBlurShader = preload("res://Assets/Shaders/motion_blur.tres")

var blur = false
var sprites : Array


func _ready():
	#adds shader to all sprites
	sprites = get_all_sprites($Body)
	print("Sprites: ", sprites)
	for s in sprites:
		s.material = ShaderMaterial.new()
		s.material.shader = MotionBlurShader
		
	#print("Sprites", sprites)
	#will stop blurring once rabbit collides with something
	connect("body_entered", self, "stop_blur")
	

func _physics_process(delta):
	if blur:
		blur()

func ability1():
	modulate = Color(1,0,0)
	linear_velocity *= speedboost
	ability_used = true
	blur()
	self.modulate = Color.red


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




func get_all_sprites(in_node,arr:=[]):
	#print("Currently checking: ", in_node, ". Here are its children: ", in_node.get_children())
	for child in in_node.get_children():
		arr = get_all_sprites(child,arr)
	if in_node is Sprite:
		print(in_node.get_name(), " is a Sprite!!!")
		arr.push_back(in_node)
	return arr
