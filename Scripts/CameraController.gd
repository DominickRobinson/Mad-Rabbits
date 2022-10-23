extends Node2D

enum CameraMode {
	close,
	far
}

enum TimeScale {
	slow_motion,
	normal_motion
}


onready var closeCamera = $CloseCamera
onready var farCamera = $FarCamera

var currentCameraMode
var currentCameraZoom

func _ready():
	useFarCamera()


func _physics_process(delta):
	#toggling camera mode
	if Input.is_action_just_pressed("switch_camera"):
		match currentCameraMode:
			CameraMode.close:
				useFarCamera()
			CameraMode.far:
				useCloseCamera()


func useFarCamera():
	#print("using far camera now...")
	
	closeCamera.global_position = farCamera.global_position
	closeCamera.zoom = farCamera.zoom
	closeCamera.current = true
	currentCameraMode = CameraMode.close

	var zoomOutTime = 1
	closeCamera.zoomTween.interpolate_property(closeCamera, "zoom", closeCamera.zoom, farCamera.zoom, zoomOutTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	closeCamera.posTween.interpolate_property(closeCamera, "global_position", closeCamera.global_position, farCamera.global_position, zoomOutTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	closeCamera.zoomTween.start()
	closeCamera.posTween.start()
	closeCamera.unfollow_player()
	
	#farCamera.current = true
	currentCameraMode = CameraMode.far

func useCloseCamera():
	#print("using close camera now...")
	closeCamera.global_position = farCamera.global_position
	closeCamera.zoom = farCamera.zoom
	closeCamera.current = true
	currentCameraMode = CameraMode.close

	var zoomInTime = 0.02
	closeCamera.zoomTween.interpolate_property(closeCamera, "zoom", closeCamera.zoom, closeCamera.originalZoom, zoomInTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	closeCamera.posTween.interpolate_property(closeCamera, "global_position", closeCamera.global_position, Manager.currentPlayer.global_position, zoomInTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	closeCamera.zoomTween.start()
	closeCamera.posTween.start()
	closeCamera.follow_player()
	
	

func slowMotion():
	#currentCamera.zoomIn(0.5, 0.5)
	closeCamera.zoom_in(0.8, 1)
	farCamera.zoom_in(0.8, 1)

func normalMotion():
	#currentCamera.zoomOut(2, 0.5)
	closeCamera.zoom_out(1.2, 0.1)
	farCamera.zoom_out(1.2, 0.1)
