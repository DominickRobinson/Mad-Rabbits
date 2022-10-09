extends RigidBody2D
class_name Character

export var cutsceneMode := false

onready var speechBubble = preload("res://Scenes/Effects/SpeechBubble.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

#useful functions for cutscenes
func change_animation(anim : String):
	if is_instance_valid($AnimationPlayer):
		$AnimationPlayer.play(anim)

func stop_animation():
	if is_instance_valid($AnimationPlayer):
		$AnimationPlayer.stop()

func speak(text : String, time : float):
	var bubble = speechBubble.instance()
	get_parent().add_child(bubble)
	
	bubble.dialogue = text
	bubble.time = time
	bubble.characterToFollow = self
	#bubble.position = position

	bubble.begin()


func freeze():
	mode = RigidBody2D.MODE_KINEMATIC

func unfreeze():
	mode = RigidBody2D.MODE_RIGID

func walk_to(final_x : int = position.x, final_y : int = position.y, time : float = 1.0):
	
	if final_x == 0:
		final_x = position.x 
	if final_y == 0:
		final_y = position.y
	
	
	change_animation("walk")
	freeze()
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(
		self, "position", 
		position, Vector2(final_x, final_y), time,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	
	yield(tween, "tween_completed")
	stop_animation()

	linear_velocity = Vector2(0,0)
	angular_velocity = 0
	
	#unfreeze()
