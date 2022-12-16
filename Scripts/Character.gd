extends RigidBody2D
class_name Character

export var cutsceneMode := false

export (bool) var show_halo := false

export (bool) var can_always_control := false

onready var speechBubble = preload("res://Scenes/Effects/SpeechBubble.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if cutsceneMode:
		unfreeze()
	if is_instance_valid(get_node("Halo")):
		if show_halo:
			$Halo.visible = true
		else:
			$Halo.visible = false

func _physics_process(delta):
	if can_always_control:
		if Input.is_action_pressed("spin_up"):
#			Manager.get_player().angular_velocity += 1
			angular_velocity += 1
#			linear_velocity.x += .1
		elif Input.is_action_pressed("spin_down"):
#			Manager.get_player().angular_velocity -= 1
			angular_velocity -= 1
#			linear_velocity.x -= .1


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


func get_all_sprites(in_node,arr:=[]):
	#print("Currently checking: ", in_node, ". Here are its children: ", in_node.get_children())
	for child in in_node.get_children():
		arr = get_all_sprites(child,arr)
	if in_node is Sprite and in_node.get_name() != "Foot":
		#(in_node.get_name(), " is a Sprite!!!")
		arr.push_back(in_node)
	return arr

