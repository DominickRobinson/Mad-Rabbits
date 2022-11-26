extends Node2D



export var play_idle := true

func _ready():
	if play_idle:
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("")
