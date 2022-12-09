extends CanvasLayer

export (Color) var panelColor := Color.white
#export (String, FILE, "*.png") var portraitFilename := ""
export (String) var catchphrase1 := "*insert catchphrase here*"
export (String) var catchphrase2 := "*insert catchphrase here*"
export (String) var catchphrase3 := "*insert catchphrase here*"
export (Color) var catchphraseOutlineColor := Color.black

func _ready():
	
	match get_parent().currentAbility:
		1:
			$Control/DialoguePanel/Catchphrase.bbcode_text = catchphrase1
		2:
			$Control/DialoguePanel/Catchphrase.bbcode_text = catchphrase2
		3:
			$Control/DialoguePanel/Catchphrase.bbcode_text = catchphrase3
	
	$Control/DialoguePanel/ColorRect.color = panelColor
	$Control/SpritePanel/ColorRect.color = panelColor
	#$Control/SpritePanel/Sprite.texture = load(portraitFilename)
#	$Control/DialoguePanel/Catchphrase.bbcode_text = catchphrase1
	$Control/DialoguePanel/Catchphrase.get("custom_fonts/normal_font").outline_color = catchphraseOutlineColor


func _physics_process(delta):
	if Input.is_action_just_pressed("hide_ui"):
		for c in get_children():
			if c.has_method("hide"):
				c.hide()
