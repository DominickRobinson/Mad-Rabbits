extends Camera2D

onready var CameraController = get_parent()

var startingPos
var player
var slingshot

var followingPlayer

var originalZoom = zoom

onready var tween = $FarTween


func _ready():
	#currentCameraZoom = ZoomMode.zoomed_out
	pass

func _process(delta):
	pass

func resetCamera():
	#followingPlayer = false
	pass

func followPlayer():
	#followingPlayer = true
	pass

func unfollowPlayer():
	#followingPlayer = false
	pass

func zoomIn(zoom_amt, speed):
	#print("far camera should be zooming in...")
	pass

func zoomOut(zoom_amt, speed):
	#print("far camera should be zooming out...")
	pass


func getTween():
	return tween
