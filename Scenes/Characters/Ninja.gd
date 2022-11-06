extends Rabbit

export (int) var speedboost := 6
export (float) var speedcrash := -.25
onready var MotionBlurShader = preload("res://Assets/Shaders/motion_blur.tres")

var blur = false
var sprites : Array


func _ready():
	catchphrase_text = "TRIPLE THREAT! HIYA!"
	#adds shader to all sprites
	sprites = get_all_sprites($Body)
	#print("Sprites: ", sprites)
	for s in sprites:
		s.material = ShaderMaterial.new()
		s.material.shader = MotionBlurShader
		
	#print("Sprites", sprites)
	#will stop blurring once rabbit collides with something
	connect("body_entered", self, "stop_blur")

func _physics_process(delta):
	if blur:
		blur()

#split into 3
func ability1():
	var copy = load(self.filename)
	newNinja(Vector2(0, -20), Color(0, 1, 0), 1.5)
	newNinja(Vector2(0, 20), Color(0, 0, 1), 1.5)
	self.modulate = Color(1, 0, 0)
	ability_used = true
	#change


#ninja kick!
func ability2():
	$Foot.visible = true
	modulate = Color(1,0,0)
	var speed = linear_velocity.length()
	linear_velocity = speedboost * Vector2(speed, 0).rotated(rotation)
	ability_used = true
	blur()
	self.modulate = Color.red


func newNinja(offset, color, vel_mult):
	var dup = load(self.filename)
	var copy = dup.instance()
	self.get_parent().add_child(copy)
	copy = copy as Rabbit
	copy.ThrowRabbit()
	copy.position = position + offset
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

func get_all_sprites(in_node,arr:=[]):
	#print("Currently checking: ", in_node, ". Here are its children: ", in_node.get_children())
	for child in in_node.get_children():
		arr = get_all_sprites(child,arr)
	if in_node is Sprite and in_node.get_name() != "Foot":
		#(in_node.get_name(), " is a Sprite!!!")
		arr.push_back(in_node)
	return arr
