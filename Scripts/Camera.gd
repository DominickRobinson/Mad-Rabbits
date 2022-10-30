extends Camera2D
class_name Cam

enum ZoomMode {
	zooming_in,
	zooming_out,
	zoomed_in,
	zoomed_out
}

var currentCameraZoom

var startingPos

var originalZoom = zoom
var blur_amount = 0

var zoomTween = Tween.new()
#onready var zoomTween = $Tween

func _init():
	startingPos = global_position
	currentCameraZoom = ZoomMode.zoomed_out
	add_child(zoomTween)
	prepare_signals()
	#print("cam")

func _ready():
	#print("cam is ready")
	pass

func _process(delta):
	#print(zoom)
	pass

func prepare_signals():
	zoomTween.connect("tween_completed", self, "on_zoom_completed")


func zoom_in(zoom_amt, speed):
	
	if currentCameraZoom == ZoomMode.zooming_out:
		#print("should be interrupting zoom in...")
		#tween.remove_all()
		#tween.stop_all()
		#currentCameraZoom = ZoomMode.zoomed_out
		zoomTween.emit_signal("tween_completed", self, "zoom")
	
	if currentCameraZoom == ZoomMode.zoomed_out:
		#print("close camera should be zooming in...")
		currentCameraZoom = ZoomMode.zooming_in
		zoomTween.interpolate_property(self, "zoom", zoom, originalZoom * zoom_amt, speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		zoomTween.start()
#		zoom = zoom * zoom_amt
#		currentCameraZoom = ZoomMode.zoomed_in

func zoom_out(zoom_amt, speed):
		
		if currentCameraZoom == ZoomMode.zooming_in:
			#print("should be interrupting zoom out...")
			#tween.remove_all()
			#tween.stop_all()
			#currentCameraZoom == ZoomMode.zoomed_in
			zoomTween.emit_signal("tween_completed", self, "zoom")
		
		if currentCameraZoom == ZoomMode.zoomed_in:
			#print("close camera should be zooming out...")
			currentCameraZoom = ZoomMode.zooming_out
			#tween.interpolate_property(self, "zoom", zoom, originalZoom * zoom_amt, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			zoomTween.interpolate_property(self, "zoom", zoom, originalZoom, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			zoomTween.start()
			#zoom = zoom * zoom_amt
			#currentCameraZoom = ZoomMode.zoomed_out

func _on_zoom_completed():
	#print("dabb")
	match currentCameraZoom:
		ZoomMode.zooming_in:
			currentCameraZoom = ZoomMode.zoomed_in
		ZoomMode.zooming_out:
			currentCameraZoom = ZoomMode.zoomed_out
		
	zoomTween.remove_all()


