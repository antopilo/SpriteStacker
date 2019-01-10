extends TextureRect

# Refs
onready var LayerButton = get_node("../Layers")
onready var Previewer = get_node("../Preview")

# Settings
var SpriteSize = Vector2(32,32)
var Layers = []
var SelectedColor = ColorN("black")
var PreviousColor = Color(0,0,0,0)
var SelectedLayer

func _init():
	MakeFolders()
func _ready():
	
	AddLayer(false)
	# Places initial layers.
	SelectedLayer = Layers[0]

func _process(delta):
	if Input.is_action_pressed("mouse1") and self.has_focus():
		DrawPixel(SelectedLayer, SelectedColor)
		
	if Layers.find(SelectedLayer,0) > 0:
		$UnderLayer.texture = Layers[Layers.find(SelectedLayer,0) - 1]
	else:
		$UnderLayer.texture = null
		
	$Editor.texture = SelectedLayer
	get_node("../Tools/VBoxContainer/ColorPickerButton").color = SelectedColor
	
func AddLayer(pRemakePreview):
	# Make image.
	var image = Image.new()
	image.create(SpriteSize.x, SpriteSize.y, false, Image.FORMAT_RGBA8)
	
	# Make ImageTexture with image.
	var tex = ImageTexture.new()
	tex.create(SpriteSize.x, SpriteSize.y, Image.FORMAT_RGBA8, 0)
	tex.set_data(image)
	
	# Add layer to the list.
	Layers.append(tex)
	LayerButton.AddButton( Layers.find(tex, 0) )
	if pRemakePreview:
		Previewer.MakePreview()
		
func LoadLayer(name):
	var image = Image.new()
	image.load(name)
	
	# Make ImageTexture with image.
	var tex = ImageTexture.new()
	tex.create_from_image(image, 0)
	tex.set_data(image)
	
	# Add layer to the list.
	Layers.append(tex)
	LayerButton.AddButton( Layers.find(tex, 0) )
	
func DrawPixel(pLayer, pColor):
	# Get Correct pixel position
	var mouse_pos = ( ( get_local_mouse_position()) / (rect_min_size / SpriteSize)) 
	
	# OutOfRange handling
	if mouse_pos.x < 0 || mouse_pos.y < 0 || mouse_pos.x > SpriteSize.x || mouse_pos.y > SpriteSize.y:
		return
	
	# Drawing on the layer.
	var data = SelectedLayer.get_data()
	data.lock()
	data.set_pixelv(mouse_pos + Vector2(0, 0), pColor)
	#data.set_pixelv(mouse_pos + Vector2(1, 0), pColor)
	#data.set_pixelv(mouse_pos + Vector2(1, 1), pColor)
	#data.set_pixelv(mouse_pos + Vector2(0, 1), pColor)
	
	SelectedLayer.set_data(data)
	data.unlock()

func SwitchLayer(id, pButton):
	SelectedLayer = Layers[id]
	
	LayerButton.resetButtons()
	pButton.text += "*"

func GetFiles(dir, any):
	var files = []
	var folder = Directory.new()
	folder.open(dir)
	folder.list_dir_begin()

	while true:
		var file = folder.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if any:
				files.append(file)
			elif file.ends_with(".png"):
				files.append(file)

	folder.list_dir_end()

	return files

func LoadFolder(dir):
	Layers.clear()
	LayerButton.ClearButtons()
	
	for files in GetFiles(dir, false):
		LoadLayer(dir + "/" + files)
	
	Previewer.MakePreview()
	SelectedLayer = Layers[0]
	
func NewSprite():
	Layers.clear()
	LayerButton.ClearButtons()
	AddLayer(true)
	SelectedLayer = Layers[0]

func _on_ColorPickerButton_color_changed(color):
	SelectedColor = color

func _on_Eraser_pressed():
	PreviousColor = SelectedColor
	SelectedColor = Color(0,0,0,0)

func _on_Pen_pressed():
	SelectedColor = PreviousColor

func RemoveLayer():
	pass
	
func MakeFolders():
	# Making user folder
	var RootFolder = Directory.new()
	RootFolder.open("user://")
	
	if !RootFolder.dir_exists("Palettes"):
		RootFolder.make_dir("Palettes")
		for file in GetFiles("res://Content/Palettes", true):
			RootFolder.copy("res://Content/Palettes/" + file, "user://Palettes/" + file)
		
	if !RootFolder.dir_exists("Output"):
		RootFolder.make_dir("Output")
		
	
			
	