extends Control

enum idk {
	nothing,
	winning,
	won,
	losing,
	lost
}

var idk_state = idk.nothing

func _ready():
	pass # Replace with function body.
	
func popupLevelCompleted(win, score):
	$Popup/ScoreValue.text = str(int(score))
	
	match idk_state:
		idk.winning:
			#print("You win!")
			idk_state = idk.won
		idk.losing:
			#print("You lost...")
			idk_state = idk.lost
	
	if win:
		$Popup/NextLevelButton.show()
		$Popup/WinLose.text = "You win!"
		
		if idk_state == idk.nothing:
			idk_state = idk.winning
	else:
		$Popup/NextLevelButton.hide()
		$Popup/WinLose.text = "You lose..."
		
		if idk_state == idk.nothing:
			idk_state = idk.losing
	
	$Popup.show()
	
	


func _on_RestartLevelButton_button_down():
	print("1")
	GameManager.RestartLevel()
	pass # Replace with function body.


func _on_NextLevelButton_button_down():
	print("2")
	GameManager.NextLevel()
	pass # Replace with function body.
