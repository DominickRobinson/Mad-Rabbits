extends StaticBody2D

export(String, FILE, "*.png") var fill := "res://icon.png"


func _ready():
	
	var polyList = get_children()
	print(polyList)
	
	for p in polyList:
		if p is CollisionPolygon2D:
			var poly = Polygon2D.new()
			poly.set_polygon(p.polygon)
			poly.texture = load(fill)
			p.add_child(poly)
		
		
	
	
