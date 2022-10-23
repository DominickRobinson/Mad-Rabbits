extends KinematicBody2D


export var expand = 1.05
export var decrease_opacity = 0.002
export var max_size = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.x *= expand
	transform.y *= expand
	#$CollisionShape2D.transform.x *= expand
	#$CollisionShape2D.transform.y *= expand
	#GameManager.slowdown()
	modulate.a = modulate.a * (1 - decrease_opacity)
	if transform.x[0] >= max_size:
		queue_free()
	pass
