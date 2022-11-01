extends Rabbit


var big = false
export var big_bounces := 2
export var big_bounce_vel_scale := 1.3


func _ready():
	catchphrase_text = "OOGA BOOGA"
	$LargeSprite.visible = false
	$LargeBody.disabled = true
	#connect("body_shape_entered", self, "bounce")
	
func ability1():
	make_big()
	self.modulate = Color.red
	ability_used = true


func make_big():
	$Sprite.visible = false
	$Body.set_deferred("disabled", true)
	$LargeSprite.visible = true
	$LargeBody.set_deferred("disabled", false)
	set_bounce(1)
	mass = 4
	contact_monitor = true
	contacts_reported = 2
	big = true

func make_small():
	$LargeSprite.visible = false
	$LargeBody.set_deferred("disabled", true)
	$Sprite.visible = true
	$Body.set_deferred("disabled", false)
	set_bounce(0.2)
	mass = 1
	contact_monitor = false
	contacts_reported = 0
	big = false


func _bounce(body):
	if big:
		big_bounces -= 1
		linear_velocity *= big_bounce_vel_scale
		if big_bounces == 0:
			make_small()

