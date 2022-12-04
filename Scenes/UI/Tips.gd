extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var children = get_children()
	for c in children:
		c = c as Control
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
	yield(get_tree().get_current_scene(), "ready")
	match Manager.CurrentGameMode:
		Manager.GameModes.Cutscene:
			$Ability.visible = false
			$Cutscene.visible = true
		Manager.GameModes.Level:
			$Ability.visible = true
			$Cutscene.visible = false
