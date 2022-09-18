extends ColorRect


var is_blurred := false
var blur_amount = 0


func _ready():
	pass # Replace with function body.

func _process(delta):
	match is_blurred:
		true:
			blurScreen()
		false:
			unblurScreen()

func blurScreen():
	blur_amount = wrapf(blur_amount + 0.05, 0.0, 5.0)
	material.set_shader_param("blur_amount", blur_amount)

func unblurScreen():
	pass
