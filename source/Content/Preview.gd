extends Control

onready var DrawingBoard = get_node("../Drawingboard")

var Layers = []
var LayerCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func GetImages():
	LayerCount = 0
	Layers.clear()
	
	for image in DrawingBoard.get_childrens():
		Layers.append( (image as TextureRect).texture)
		LayerCount += 1
		
func MakeModel():
	GetImages()
	
	for i in LayerCount:
		var currentSprite = Sprite.new()
		currentSprite.name = i.name
		currentSprite.texture = Layers[i]
		currentSprite.position = Vector2(200, 200 - i)
		$Model.add_child(currentSprite)