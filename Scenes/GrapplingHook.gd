"""
This script controls the chain.
"""
# https://youtu.be/Wzrw6_KDMl4

extends Node2D

onready var links = $Links
onready var tip = $Tip
var direction := Vector2(0,0)
var tip_pos := Vector2(0,0)

const SPEED = 50	

var flying = false
var hooked = false

func shoot(dir: Vector2) -> void:
	direction = dir.normalized()
	flying = true
	tip_pos = self.global_position

func release() -> void:
	flying = false
	hooked = false

func _process(_delta: float) -> void:
	self.visible = flying or hooked	# Only visible if flying or attached to something
	if not self.visible:
		return

	var tip_loc = to_local(tip_pos)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	links.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	tip.rotation = self.position.angle_to_point(tip_loc) - deg2rad(90)
	links.position = tip_loc						# The links are moved to start at the tip
	links.region_rect.size.y = tip_loc.length()		# and get extended for the distance between (0,0) and the tip

# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	tip.global_position = tip_pos	
	if flying:
		# `if move_and_collide()` always moves, but returns true if we did collide
		if tip.move_and_collide(direction * SPEED):
			hooked = true
			flying = false
	tip_pos = tip.global_position
