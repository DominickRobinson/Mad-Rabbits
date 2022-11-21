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
	$Popup.hide()
	#$Popup.show()



func popupLevelCompleted(win):
	Manager.slowdown(0.1)
	match idk_state:
		idk.winning:
			#print("You win!")
			idk_state = idk.won
		idk.losing:
			#print("You lost...")
			idk_state = idk.lost
	
	if win:
		$Popup/NextLevelButton.show()
		$Popup/WinLose.bbcode_text = "[center]You win!"
		
		if idk_state == idk.nothing:
			idk_state = idk.winning
	else:
		$Popup/NextLevelButton.hide()
		$Popup/WinLose.bbcode_text = "[center]You lose..."
		
		if idk_state == idk.nothing:
			idk_state = idk.losing
	
	$Popup.show()
	
	


func _on_RestartLevelButton_button_down():
	#print("1")
	Manager.reload()
	pass # Replace with function body.


func _on_NextLevelButton_button_down():
	#print("2")
	Manager.next_level()
	pass # Replace with function body.
