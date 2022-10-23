extends Node2D


export (String, FILE, "*.mp3") var music := ""

func _ready():
	#self.add_to_group("Level")
	Manager.playAudio(music, -5, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
