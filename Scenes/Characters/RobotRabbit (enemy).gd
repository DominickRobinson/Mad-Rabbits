extends Bear



const explosion = preload("res://Scenes/Effects/ExplosionTNT.tscn")
onready var Smoke = preload("res://Scenes/Effects/GunSmoke.tscn")
export (int) var time_to_explode := 3
export (bool) var explode := true

var exploded = false


func die():
	Manager.playAudio(deathNoise)
	
	make_explosion(1,2)
	
	queue_free()


func _on_Area2D_body_entered(body):
	if not explode or exploded:
		return
	if body.is_in_group("Rabbits"):
		$Body/BodySprite.animation = "mad"
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(.2,0,0,1), time_to_explode, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		yield($Tween, "tween_completed")
		make_explosion(1,1)
		exploded = true


func make_explosion(s,s2):
	var e = explosion.instance()
	e.global_position = global_position
	e.scale *= s
	get_tree().get_current_scene().add_child(e)
	shoot_smoke(s2)
	shoot_smoke(s2*1.5)

func shoot_smoke(s):
	var smoke = Smoke.instance()
	smoke.scale *= s
	smoke.global_position = global_position
	smoke.emitting = true
	get_tree().get_current_scene().add_child(smoke)
