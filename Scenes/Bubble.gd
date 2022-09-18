extends Control


export var text := ""

export var bubble_color := Color(1,1,1)

export var despawn_timer := 2

onready var Bubble = $Sprite
onready var Text = $Sprite/Label
onready var Timer = $Timer

var transparency = 1

func _ready():
	Timer.wait_time = despawn_timer
	visible = false
	Text.text = text
	Bubble.modulate = bubble_color
	activate()

func _physics_process(delta):
	transparency = lerp(transparency, 0, 0.05)
	Bubble.modulate.a = transparency
	pass

func activate():
	if visible == false:
		visible = true
		Timer.start()

func _on_Timer_timeout():
	queue_free()

func update():
	changeColor()
	changeText()

func changeColor():
	Bubble.modulate = bubble_color

func changeText():
	Text.text = text
