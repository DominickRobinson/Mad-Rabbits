extends Container


#var children
#
#func _ready():
#	children = get_children()
#
#
#func _process(delta):
#	for child in children:
#		var grandchildren = child.get_children()
#		for grandchild in grandchildren:
#			print(grandchild.get_name())
#			if grandchild is Button:
#				if grandchild.pressed:
#					grandchild.modulate = Color.mediumspringgreen
#				else:
#					grandchild.modulate = Color.white
