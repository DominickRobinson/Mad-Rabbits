extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var duration := 0.8

var time
var flipping := false

var current_scene
var t
var page
var img
var transition_sprite

var display_flip = true
var flip_left = true

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = get_tree().root.get_child(get_tree().root.get_child_count()-1)

func change_scene(new_scene:String):
	# get texture
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png("res://transition.png")
#	print("Change scene - flip_left: ", flip_left)
	get_tree().change_scene(new_scene)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	transition_sprite = texture



