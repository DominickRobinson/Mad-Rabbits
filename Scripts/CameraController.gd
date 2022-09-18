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
onready var currentCamera

var currentCameraMode
var currentCameraZoom
var currentTimeScale

var followingPlayer


func _ready():
	#useFarCamera()
	useCloseCamera()
	currentTimeScale = TimeScale.normal_motion


func _physics_process(delta):
	
	#toggling camera mode
	if Input.is_action_just_pressed("switch_camera"):
		match currentCameraMode:
			CameraMode.close:
				useFarCamera()
			CameraMode.far:
				useCloseCamera()
				
#	elif Input.is_action_just_pressed("return_to_slingshot"):
#		currentCamera.resetCamera()


func useFarCamera():
	print("using far camera now...")
	farCamera.current = true
	currentCameraMode = CameraMode.far
	currentCamera = farCamera

func useCloseCamera():
	print("using close camera now...")
	closeCamera.current = true
	currentCameraMode = CameraMode.close
	currentCamera = closeCamera

func resetCamera():
	currentCamera.resetCamera()

func followPlayer():
	followingPlayer = true
	closeCamera.followPlayer()
	farCamera.followPlayer()

func unfollowPlayer():
	followingPlayer = false
	closeCamera.unfollowPlayer()
	farCamera.unfollowPlayer()

func toggleSlowMotion():
	if currentTimeScale == TimeScale.normal_motion:
		pass
	pass

func slowMotion():
	#currentCamera.zoomIn(0.5, 0.5)
	closeCamera.zoomIn(0.8, 1)
	farCamera.zoomIn(0.8, 1)

func normalMotion():
	#currentCamera.zoomOut(2, 0.5)
	closeCamera.zoomOut(1.2, 0.1)
	farCamera.zoomOut(1.2, 0.1)

func getCurrentCamera():
	return currentCamera
