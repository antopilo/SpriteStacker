extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	
	draw_set_transform(Vector2(), 0, Vector2(20,20))

	for y in range(0, 32):
		draw_line(Vector2(0, y), Vector2(32, y), Color("e6999999"))

	for x in range(0, 32):
		draw_line(Vector2(x, 0), Vector2(x, 32), Color("e6999999"))
