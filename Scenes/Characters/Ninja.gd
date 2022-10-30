extends Rabbit

func _ready():
	catchphrase_text = "TRIPLE THREAT! HIYA!"
	

func ability1():
	
	var copy = load(self.filename)
	
	newNinja(Vector2(0, -10), Color(0, 1, 0), 1.5)
	newNinja(Vector2(0, 10), Color(0, 0, 1), 1.5)
	
	self.modulate = Color(1, 0, 0)
	
	ability_used = true


func newNinja(offset, color, vel_mult):
	
	var dup = load(self.filename)
	var copy = dup.instance()
	self.get_parent().add_child(copy)
	
	copy = copy as Rabbit
	
	copy.ThrowRabbit()
	
	copy.position = position + offset
	copy.linear_velocity = (linear_velocity + offset) * vel_mult
	copy.angular_velocity = angular_velocity * vel_mult
	copy.ability_used = true
	copy.modulate = color
	copy.remove_from_group("Player")
	
