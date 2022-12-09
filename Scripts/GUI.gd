extends CanvasLayer

#export (String, "triumphant", "elegant", "ambient", "happy/slightly chill",
#				"tense/ominous", "hopeful", "title", "church", "iconic/chaotic",
#				"villainous", "none") var music := "none"

export (String, "battle_brutal",
				"battle_decisive",
				"battle_dramatic",
				"battle_final_chanting",
				"battle_guitar",
				"chapter_card",
				"church_death",
				"death_chip",
				"fun_piano",
				"graceful_classical",
				"happy_chill",
				"happy_elegant",
				"honkey",
				"iconic_chaos",
				"lowkey_sad",
				"meeting_god",
				"opera",
				"optimistic_flowy_adventuring",
				"royal_sophisticated",
				"tense_ominous",
				"title_hopeful",
				"triumphant",
				"villain",
				"none") var music := "none"


export (String, MULTILINE) var text := "There once was a rabbit..."

export (bool) var is_chapter_page := false

onready var Score = $Score
onready var EndOfLevel = $EndOfLevel
onready var pauseMenu = $PauseMenu

var children = [Score, EndOfLevel]

func _ready():
#	Manager.play_music(music)
	play_music()
	
	if is_chapter_page:
		$StoryText.queue_free()
		$GameplayUtilityBar.queue_free()
	else:
		$StoryText/VBoxContainer/Label.text = text
		if text == "":
			$StoryText.visible = false
		#EndOfLevel.visible = false
		$GameplayUtilityBar.visible = true
	
	$PageNumber.visible = true
	

func _physics_process(delta):
	if Input.is_action_just_pressed("hide_ui"):
		for c in get_children():
			if c.has_method("hide"):
				c.hide()


func PopupLevelCompleted(win):
	EndOfLevel.popupLevelCompleted(win)

func hideAllChildren():
	for child in children:
		child.visible = false

func showOnlyOneChild(child):
	hideAllChildren()
	child.visible = true

func pause(toggle):
	pauseMenu.set_is_paused(toggle)

func play_music():
	var song_filename = "res://Assets/Sound/Music/" + music + ".mp3"
#	song_filename =  "res://Assets/Sound/Music/iconic_chaos.mp3"
	#print(song_filename)
	$Music.stream = load(song_filename)
	$Music.play()
