extends Rabbit


var is_big = false
#export var big_health := 75


func _ready2():
	catchphrase_text = "OOGA BOOGA"
	$LargeSprite.visible = false
	$LargeBody.disabled = true


func ability():
	$Sprite.visible = false
	$Body.set_deferred("disabled", true)
	
	$LargeSprite.visible = true
	$LargeBody.set_deferred("disabled", false)
	set_bounce(1)
	set_friction(0)
	mass = 4
	#print(friction)
	ability_used = true
	pass


