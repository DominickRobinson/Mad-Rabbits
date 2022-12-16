extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetScore():
#	$ScoreValue.text = str(int(Manager.Score))
	pass
	
func PopupLevelCompleted(win, score):
	$Popup/ScoreValue.text = str(int(score))
	
	if win:
		$Popup/NextLevelButton.show()
		$Popup/WinLose.text = "You win!"
	else:
		$Popup/NextLevelButton.hide()
		$Popup/WinLose.text = "You lose..."
	
	$Popup.show()
	
	


func _on_RestartLevelButton_button_down():
	Manager.RestartLevel()
	pass # Replace with function body.


func _on_NextLevelButton_button_down():
	Manager.NextLevel()
	pass # Replace with function body.
