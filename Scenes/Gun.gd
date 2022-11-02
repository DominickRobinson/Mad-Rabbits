extends Node2D

export var initially_visible := false
export var bullet_speed := 600

signal shot_bullet(velocity, direction, mass)

onready var Smoke = preload("res://Scenes/Effects/GunSmoke.tscn")
onready var Bullet = preload("res://Scenes/Bullet.tscn")

func _ready():
	visible = initially_visible
	#$AnimationPlayer.play("fire")

#func _physics_process(delta):
#	global_rotation = get_angle_to(get_global_mouse_position())
#	if 90 <= fmod(global_rotation_degrees, 360) and fmod(global_rotation_degrees, 360) <= 270:
#		scale.y = -1
#	else:
#		scale.y = 1


func fire():
	visible = true
	$AnimationPlayer.play("fire")

func shoot_smoke():
	var smoke = Smoke.instance()
	add_child(smoke)
	smoke.global_position = $GunPoint.global_position
	smoke.emitting = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fire":
		visible = false


func fire_bullet():
	
	shoot_smoke()
	var bullet = Bullet.instance()
	get_tree().get_current_scene().add_child(bullet)
	var dir = Vector2(cos(global_rotation), sin(global_rotation))
	bullet.linear_velocity = dir * bullet_speed 
	bullet.global_rotation = global_rotation
	bullet.global_position = $GunPoint.global_position
	
	emit_signal("shot_bullet")
	
