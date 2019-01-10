extends Control
onready var DrawingBoard = get_node("../Drawingboard")
onready var ItemContainer = get_node("ItemContainer")
var ColorsInPalette = []
"""
== EDG32 ==
be4a2f, d77643, ead4aa, e4a672, b86f50, 733e39, 3e2731, 
a22633, e43b44, f77622, feae34, fee761, 63c74d, 3e8948,
265c42, 193c3e, 124e89, 0099db, 2ce8f5, ffffff, c0cbdc,
8b9bb4, 5a6988, 3a4466, 262b44, 181425, ff0044, 68386c,
b55088, f6757a, e8b796, c28569
"""
	
func LoadHexFile(pName):
	var newFile = File.new()
	
	newFile.open(pName, File.READ)
	var Lines = newFile.get_as_text().split("\n")
	LoadPalette(Lines)
	newFile.close()
	
func LoadPalette(pPalette):
	ItemContainer.clear()
	ColorsInPalette = pPalette
	
	for color in pPalette:
		AddColor(Color(color))
		
		
		
func AddColor(pColor):
	var newImage = Image.new()
	newImage.create(30, 30,false,Image.FORMAT_RGBA8)
	newImage.fill(pColor)
	
	var newTexture = ImageTexture.new()
	newTexture.create(30, 30, Image.FORMAT_RGBA8, 0)
	newTexture.set_data(newImage)
	
	ItemContainer.add_icon_item(newTexture)
	ColorsInPalette.append(Color(pColor))
	
func _on_ItemContainer_item_selected(index):
	DrawingBoard.SelectedColor = ColorsInPalette[index]
