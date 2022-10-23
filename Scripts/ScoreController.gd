extends Control


func _ready():
	pass # Replace with function body.

func setScore():
	$ScoreValue.text = str(int(Manager.Score))

