extends Control

onready var DrawingBoard = get_node("../Drawingboard")
onready var Layers = get_node("../Drawingboard").Layers
var Rotating = false
var speed = 0.25
var MoveStep = 2
var offset = Vector2()
var currentScale = 25
var ResolutionStep = 16
# Called when the node enters the scene tree for the first time.
func _ready():
	MakePreview()

func _physics_process(delta):
	if Rotating:
		for i in $ViewportContainer/Viewport/Model.get_children():
			i.rotation_degrees += speed
	
func MakePreview():
	# Loop through layers
	ClearPreview()
	var index = 0
	for i in Layers:
		var newSprite = Sprite.new()
		newSprite.scale = DrawingBoard.SpriteSize / 4
		newSprite.texture = i 
		newSprite.centered = true
		newSprite.position.y -= index * newSprite.scale.x
		newSprite.position += offset # offset height
		$ViewportContainer/Viewport/Model.add_child(newSprite)
		
		index += 1
func ClearPreview():
	
	for i in $ViewportContainer/Viewport/Model.get_children():
		i.queue_free()
func UpdatePreview():
	var index = 0
	for i in $ViewportContainer/Viewport/Model.get_children():
		i.position = offset - Vector2(0, index * i.scale.x )
		index += 1
	

func _on_HSlider_value_changed(value):
	var temp = Rotating
	Rotating = false
	for i in $ViewportContainer/Viewport/Model.get_children():
		i.rotation_degrees = value
		UpdatePreview()
	Rotating = temp

func _on_RotateToggle_toggled(button_pressed):
	Rotating = button_pressed


func _on_HSlider2_value_changed(value):
	for i in get_node("ViewportContainer/Viewport/Model").get_children():
		currentScale = value
		i.scale = Vector2(currentScale, currentScale)
	UpdatePreview()

func _on_Right_pressed():
	offset.x += MoveStep * currentScale
	UpdatePreview()

func _on_Left_pressed():
	offset.x -= MoveStep * currentScale
	UpdatePreview()

func _on_Up_pressed():
	offset.y -= MoveStep * currentScale
	UpdatePreview()

func _on_Down_pressed():
	offset.y += MoveStep * currentScale
	UpdatePreview()

func IncreaseResolution():
	$ViewportContainer/Viewport.size += Vector2(16, 16)
	$ViewportContainer.stretch_shrink = round(400 / $ViewportContainer/Viewport.size.x)
	
func DecreaseResolution():
	$ViewportContainer/Viewport.size -= Vector2(16, 16)
	$ViewportContainer.stretch_shrink = round(400 / $ViewportContainer/Viewport.size.x)
	
func Center():
	offset = $ViewportContainer/Viewport.size / Vector2($ViewportContainer.stretch_shrink,
		$ViewportContainer.stretch_shrink)
	UpdatePreview()