extends CanvasLayer


onready var Score = $Score
onready var EndOfLevel = $EndOfLevel


var children = [Score, EndOfLevel]

func _ready():
	pass # Replace with function body.

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
