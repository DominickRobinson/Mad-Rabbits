extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var expand = 1.05
export var decrease_opacity = 0.02

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.x *= expand
	transform.y *= expand
	$CollisionShape2D.transform.x *= expand
	$CollisionShape2D.transform.y *= expand
	modulate.a = modulate.a - decrease_opacity
	if modulate.a <= 0.2:
		queue_free()
	pass
