extends CanvasLayer


export var duration := 1.2

var time = 0
var flipping := true
var t

onready var page := $Page
onready var cover := $Cover

# This leaves an extra canvaslayer in the scene
# Not a big problem though, I'll deal with it later
# Called when the node enters the scene tree for the first time.
func _ready():
	page.visible = true
	t = ChangeScene.transition_sprite
	cover.texture = t
	page.material.set_shader_param("previous_page", t)
	page.material.set_shader_param("time", 0)
	page.material.set_shader_param("flip_duration", duration)
	page.material.set_shader_param("cylinder_ratio", 0.6)
	page.material.set_shader_param("rect", page.rect_size)
	page.material.set_shader_param("flip_left", ChangeScene.flip_left)
#	page.material.set_shader_param("flip_left", true)
#	print("Transition - flip_left: ", ChangeScene.flip_left)
	page.material.set_shader_param("cylinder_direction", Vector2(5.0, 5.0))
	

func _process(delta):
	cover.visible = false
	if flipping:
		time += delta
		page.material.set_shader_param("time", time)
		if time > duration:
			flipping = false
			page.queue_free()
			
