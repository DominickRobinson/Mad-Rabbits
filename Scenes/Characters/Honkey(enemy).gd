extends Bear

export var dead := false


func _ready():
	if dead:
		$AnimatedSprite.animation = "dead"
		modulate = Color(.2,.2,.2)
	else:
		$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play()
