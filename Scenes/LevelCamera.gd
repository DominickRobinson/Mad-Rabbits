extends Camera2D

export (float) var slomoZoom := 0.95
export (float) var abilityZoom := 0.5

export (float) var slomoZoomInSpeed := 4
export (float) var slomoZoomOutSpeed := 0.2

export (float) var abilityZoomInSpeed := 0.8
export (float) var abilityZoomOutSpeed := 0.5

onready var background = get_parent().get_node("Background")

enum ZoomMode {
	zooming_in,
	zooming_out,
	zoomed_in,
	zoomed_out
}

enum FollowMode {
	willFollow,
	following,
	willNotFollow,
	notFollowing
}

var currentCameraZoom
var currentCameraFollow

var startingPos
var startingZoom

var blur_amount = 0

var zoomTween
var posTween

var b = false

func _ready():
	if not is_instance_valid(background):
		background = get_parent().get_node("Background2")
	#global_position = background.global_position
	currentCameraZoom = ZoomMode.zoomed_out
	currentCameraFollow = FollowMode.notFollowing
	zoomTween = Tween.new()
	add_child(zoomTween)
	posTween = Tween.new()
	add_child(posTween)
	prepare_signals()
	set_limits()
	
	yield(get_tree().create_timer(0.1), "timeout")
	startingPos = global_position
	startingZoom = zoom



func _process(delta):
	if b == false:
		if Manager.CurrentGameMode == Manager.GameModes.Level:
			set_collision_boundaries()
		b = true
		
	match currentCameraFollow:
		FollowMode.following:
			if is_instance_valid(Manager.last_rabbit_thrown()):
				global_position = Manager.last_rabbit_thrown().global_position
			else:
				currentCameraFollow = FollowMode.notFollowing



func slowMotion():
	#zoom_in(slomoZoom, slomoZoomInSpeed)
	pass

func normalMotion():
	#zoom_out(slomoZoomOutSpeed)
	pass


func abilityZoomIn():
	get_tree().paused = true
	zoom_in(abilityZoom, abilityZoomInSpeed)
	trackPlayerPosition()
	
	
	yield(zoomTween, "tween_completed")
	get_tree().paused = false
	follow_player()

func abilityZoomOut():
	unfollow_player()
	#get_tree().paused = true
	zoom_out(abilityZoomOutSpeed)
	untrackPlayerPosition()
	
	yield(zoomTween, "tween_completed")
	yield(posTween, "tween_completed")
	#get_tree().paused = false



func follow_player():
	currentCameraFollow = FollowMode.following

func unfollow_player():
	currentCameraFollow = FollowMode.notFollowing


func trackPlayerPosition():
	posTween.interpolate_property(self, "global_position", null, Manager.get_player().global_position, abilityZoomInSpeed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	posTween.start()

func untrackPlayerPosition():
	posTween.interpolate_property(self, "global_position", null, startingPos, abilityZoomOutSpeed/2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	posTween.start()


func zoom_in(zoom_amt, speed):
	
	if currentCameraZoom == ZoomMode.zooming_out:
		#print("should be interrupting zoom in...")
		#tween.remove_all()
		#tween.stop_all()
		#currentCameraZoom = ZoomMode.zoomed_out
		zoomTween.emit_signal("tween_completed")
	
	if currentCameraZoom == ZoomMode.zoomed_out:
		#print("close camera should be zooming in...")
		currentCameraZoom = ZoomMode.zooming_in
		zoomTween.interpolate_property(self, "zoom", zoom, Vector2.ONE * zoom_amt, speed * Engine.time_scale, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		zoomTween.start()
		#print("zoom in now")
#		zoom = zoom * zoom_amt
#		currentCameraZoom = ZoomMode.zoomed_in

func zoom_out(speed):
		if currentCameraZoom == ZoomMode.zooming_in:
			#currentCameraZoom == ZoomMode.zoomed_in
			zoomTween.emit_signal("tween_completed")
		
		if currentCameraZoom == ZoomMode.zoomed_in:
			currentCameraZoom = ZoomMode.zooming_out
			zoomTween.interpolate_property(self, "zoom", zoom, startingZoom, speed * Engine.time_scale, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			zoomTween.start()


func _on_zoomTween_completed():
	match currentCameraZoom:
		ZoomMode.zooming_in:
			currentCameraZoom = ZoomMode.zoomed_in
			#print("zoomed in")
		ZoomMode.zooming_out:
			currentCameraZoom = ZoomMode.zoomed_out
			#print("zoomed out")
		
	zoomTween.remove_all()



func prepare_signals():
	zoomTween.connect("tween_completed", self, "_on_zoomTween_completed")
	#posTween.connect("tween_completed", self, "on_posTween_completed")


func set_limits():
	var scale_x = abs(background.scale.x)
	var scale_y = abs(background.scale.y)
	limit_left = background.global_position.x - scale_x * background.texture.get_width()/2
	limit_right = background.global_position.x + scale_x * background.texture.get_width()/2
	limit_top = background.global_position.y - scale_y * background.texture.get_height()/2
	limit_bottom = background.global_position.y + scale_y * background.texture.get_height()/2
	
	var lims = [limit_left, limit_right, limit_top, limit_bottom]
	var limc = ['l', 'r', 't', 'b']

#	print("Background texture width: ", background.texture.get_width()/2)
#	print("Background texture height: ", background.texture.get_height()/2)
	for x in range(4):
		print(str(limc[x]), ": ", str(lims[x]))


func set_collision_boundaries():
	#draw collision shape boundary
	yield(get_tree().create_timer(1.0), "timeout")
	var area = StaticBody2D.new()
	get_tree().get_current_scene().add_child(area)
	
	#left collision rectangle
	var l_shape = RectangleShape2D.new()
	l_shape.set_extents(Vector2(100, 3000))
	var l_collision = CollisionShape2D.new()
	l_collision.global_position.x = limit_left - 50
	l_collision.set_shape(l_shape)
	area.add_child(l_collision)
	
	#right collision rectangle
	var r_shape = RectangleShape2D.new()
	r_shape.set_extents(Vector2(100, 2000))
	var r_collision = CollisionShape2D.new()
	r_collision.global_position.x = limit_right + 50
	r_collision.set_shape(r_shape)
	area.add_child(r_collision)


