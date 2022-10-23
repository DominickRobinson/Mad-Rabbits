extends CanvasLayer


onready var Score = $Score
onready var EndOfLevel = $EndOfLevel
onready var pauseMenu = $PauseMenu

var children = [Score, EndOfLevel]

func _ready():
	#EndOfLevel.visible = false
	pass

func SetScore():
	Score.setScore()

func PopupLevelCompleted(win, score):
	EndOfLevel.popupLevelCompleted(win, score)

func hideAllChildren():
	for child in children:
		child.visible = false

func showOnlyOneChild(child):
	hideAllChildren()
	child.visible = true

func pause(toggle):
	pauseMenu.set_is_paused(toggle)
