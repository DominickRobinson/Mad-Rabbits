extends Bear

export var dead := false


func _ready():
	if dead:
		$AnimatedSprite.animation = "dead"
	else:
		$AnimatedSprite.animation = "idle"
	$AnimatedSprite.play()
