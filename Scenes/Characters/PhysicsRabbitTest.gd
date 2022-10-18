extends Rabbit


func ability():
	modulate = Color(1,0,0)
	linear_velocity *= 2
	
	GameManager.playAudio(catchphrase_filename)
	
	ability_used = true
	
