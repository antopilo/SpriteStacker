extends Control

#Refs
onready var DrawingBoard = get_node("../Drawingboard")

var path = str(OS.get_executable_path()).rstrip("/SpriteStacker.exe")
var dir = "newsprite"

func ExportPNG():
	var index = 0
	var target = Directory.new()
	target.open(path)
	if !target.dir_exists(dir): 
		target.make_dir(dir)
		
	for image in DrawingBoard.Layers:
		if target.file_exists(dir + "/" + str(index) + ".png"):
			target.remove(dir + "/" + str(index) + ".png")
		print(path + dir + "/" + str(index) + ".png")
		image.get_data().save_png(path + dir + "/" + str(index) + ".png")
		index += 1
		


func _on_LineEdit_text_changed(new_text):
	dir = new_text

func _on_FileDialog_dir_selected(dir):
	DrawingBoard.LoadFolder(dir)
	$LineEdit.text = dir.split("/")[dir.split("/").size() - 1]

func _on_Import_pressed():
	$Import/FileDialog.popup_centered(Vector2(800, 500) )
	
func _on_LoadPalette_pressed():
	$LoadPalette/FileDialog.popup_centered(Vector2(800,500))

func _on_FileDialog_file_selected(path):
	var node = get_node("../PalettePicker")
	node.LoadHexFile(path)


func _on_Button_pressed():
	DrawingBoard.NewSprite()
