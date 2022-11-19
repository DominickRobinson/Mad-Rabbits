extends Cam

var posTween = Tween.new()

var followingPlayer = false

func _ready():
	#print("close camera")
	add_child(posTween)

func follow_player():
	followingPlayer = true

func unfollow_player():
	followingPlayer = false

func _physics_process(delta):
	if followingPlayer:
		global_position = Manager.currentPlayer.global_position
