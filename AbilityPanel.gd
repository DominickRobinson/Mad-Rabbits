extends CanvasLayer

export (Color) var panelColor := Color.white
export (String, FILE, "*.png") var portraitFilename := ""
export (String) var catchphrase := "*insert catchphrase here*"
export (Color) var catchphraseOutlineColor := Color.black

func _ready():
	$Control/DialoguePanel/ColorRect.color = panelColor
	$Control/SpritePanel/ColorRect.color = panelColor
	$Control/SpritePanel/Sprite.texture = load(portraitFilename)
	$Control/DialoguePanel/Catchphrase.bbcode_text = catchphrase
	$Control/DialoguePanel/Catchphrase.get("custom_fonts/normal_font").outline_color = catchphraseOutlineColor
