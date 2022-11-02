extends RigidBody2D

onready var trail = preload("res://Scenes/Effects/VaporTrail.tscn")

var flying = true

func _ready():
	pass

func _physics_process(delta):
	if flying:
		var t = trail.instance()
		get_tree().current_scene.add_child(t)
		t.global_position = global_position
		t.emitting = true

func _on_Bullet_body_entered(body):
	flying = false
