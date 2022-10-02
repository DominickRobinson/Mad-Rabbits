extends Rabbit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready2():
	catchphrase_text = "OOGA BOOGA"
	#counter = 2
	#pass # Replace with function body.

func ability():
	$Sprite.modulate = Color(1,0,0)
	self.linear_velocity.y -= 50
	self.counter -= 1
	#if counter == 0:
		#ability_used = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
