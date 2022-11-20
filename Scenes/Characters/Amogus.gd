extends Rabbit




func _ready():
	catchphrase_text = "JUMPY IMPOSTER"
	#counter = 2
	#pass # Replace with function body.

func ability1():
	$Sprite.modulate = Color(1,0,0)
	self.linear_velocity.y -= 200
	self.counter -= 1
	if counter == 0:
		ability_used = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
