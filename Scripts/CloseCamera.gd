extends Camera2D


enum ZoomMode {
	zooming_in,
	zooming_out,
	zoomed_in,
	zoomed_out
}

var currentCameraZoom

var startingPos
var player
var slingshot

var followingPlayer
var originalZoom = zoom
var blur_amount = 0

onready var tween = $CloseTween
onready var ztween = $CloseTweenZoom


func _ready():
	startingPos = global_position
	player = findPlayer()
	slingshot = get_tree().get_nodes_in_group("Slingshot")[0]
	currentCameraZoom = ZoomMode.zoomed_out

func _process(delta):
	#what to do when supposed to be following player
	if followingPlayer:
		
		player = findPlayer()
		
		if is_instance_valid(player):
			
			#if player.position.x > position.x:
			if player.position.x > global_position.x:
				var playerPos = clamp(player.position.x, -5000, 5000)
				global_position = Vector2(playerPos, startingPos.y)
		else:
			tween.interpolate_property(self, "position", position, startingPos, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()

func resetCamera():
	unfollowPlayer()
	
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		tween.interpolate_property(self, "position", position, startingPos, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		zoomOut(1, 0.01)

func followPlayer():
	followingPlayer = true

func unfollowPlayer():
	followingPlayer = false

func findPlayer():
	return GameManager.currentPlayer

func getTween():
	return tween

func zoomIn(zoom_amt, speed):
	
	if currentCameraZoom == ZoomMode.zooming_out:
		print("should be interrupting zoom in...")
		#tween.remove_all()
		#tween.stop_all()
		#currentCameraZoom = ZoomMode.zoomed_out
		ztween.emit_signal("tween_completed", self, "zoom")
	
	if currentCameraZoom == ZoomMode.zoomed_out:
		print("close camera should be zooming in...")
		currentCameraZoom = ZoomMode.zooming_in
		ztween.interpolate_property(self, "zoom", zoom, originalZoom * zoom_amt, speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		ztween.start()
#		zoom = zoom * zoom_amt
#		currentCameraZoom = ZoomMode.zoomed_in

func zoomOut(zoom_amt, speed):
		
		if currentCameraZoom == ZoomMode.zooming_in:
			print("should be interrupting zoom out...")
			#tween.remove_all()
			#tween.stop_all()
			#currentCameraZoom == ZoomMode.zoomed_in
			ztween.emit_signal("tween_completed", self, "zoom")
		
		if currentCameraZoom == ZoomMode.zoomed_in:
			print("close camera should be zooming out...")
			currentCameraZoom = ZoomMode.zooming_out
			#tween.interpolate_property(self, "zoom", zoom, originalZoom * zoom_amt, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			ztween.interpolate_property(self, "zoom", zoom, originalZoom, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			ztween.start()
			#zoom = zoom * zoom_amt
			#currentCameraZoom = ZoomMode.zoomed_out

func _on_CloseTween_tween_completed(object, key):
	match currentCameraZoom:
		ZoomMode.zooming_in:
			currentCameraZoom = ZoomMode.zoomed_in
		ZoomMode.zooming_out:
			currentCameraZoom = ZoomMode.zoomed_out
		
	tween.remove_all()


func _on_CloseTweenZoom_tween_completed(object, key):
	match currentCameraZoom:
		ZoomMode.zooming_in:
			currentCameraZoom = ZoomMode.zoomed_in
		ZoomMode.zooming_out:
			currentCameraZoom = ZoomMode.zoomed_out
		
	ztween.remove_all()
