extends Rabbit

func _ready():
	pass


#friendship
func ability1():
	var rabbits = get_tree().get_nodes_in_group("Rabbits")
	
	for r in rabbits:
		if r != self and r.ability_used == false and r.state == RabbitState.thrown:
			r.ability()
