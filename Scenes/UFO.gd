extends Node2D


export var play_idle := true
export var engine_on := false

func _ready():
	if play_idle:
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("")
	
	if engine_on:
		$StaticBody2D/Sprite/Engine.play("on")
	else:
		$StaticBody2D/Sprite/Engine.play("off")
