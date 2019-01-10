extends TextureRect

var editableImage
var imageSize = Vector2(64, 64)
var imageFormat = Image.FORMAT_RGBA8
var imageTexture
var currentColor = ColorN("black")

func _ready():
	#Image is a built-in type
	editableImage = Image.new()
	editableImage.create(imageSize.x, imageSize.y, false, imageFormat)
	
	imageTexture = ImageTexture.new()
	imageTexture.create(imageSize.x,imageSize.y, imageFormat, 0)    
	imageTexture.set_data(editableImage)
	
	set_texture(imageTexture)
	
func _process(delta):
	if Input.is_action_pressed("mouse1"):
		var mouse_pos = ( ( get_local_mouse_position()) / (rect_min_size / imageSize)) 
		
		# OOR 
		if mouse_pos.x < 0 || mouse_pos.y < 0 || mouse_pos.x > imageSize.x || mouse_pos.y > imageSize.y:
			printerr("Mouse Position Out of range : " + str(mouse_pos))
			return
			
		editableImage.lock()
		
		editableImage.set_pixelv(mouse_pos, currentColor)
		imageTexture.set_data(editableImage)
		
		editableImage.unlock()


func _on_ColorPickerButton_color_changed(color):
	currentColor = color


func _on_Eraser_pressed():
	currentColor = Color(0,0,0,0)
