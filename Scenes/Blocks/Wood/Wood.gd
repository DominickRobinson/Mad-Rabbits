extends Brick



func _ready2():
	#print("ready")
	max_health = 100
	contact_monitor = true
	contacts_reported = 1
	self.connect("body_entered", self, "on_Brick_body_entered")
	pass




func _on_Wood_body_entered(body):
	_on_Brick_body_entered(body)
