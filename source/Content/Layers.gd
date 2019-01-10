extends Control

onready var DrawingBoard = get_node("../Drawingboard")
func AddButton(id):
	var VBox = get_node("Panel/HBoxContainer/ScrollContainer/VBoxContainer")
	var DrawingBoard = get_node("../Drawingboard")
	
	var newButton = Button.new()
	newButton.text = str(id)
	newButton.size_flags_horizontal = SIZE_FILL
	newButton.focus_mode = Control.FOCUS_NONE
	newButton.rect_min_size = Vector2(0, 25)
	newButton.connect( "pressed", DrawingBoard, "SwitchLayer", [id, newButton] )
	
	VBox.add_child( newButton )
	
func _on_NewLayer_pressed():
	DrawingBoard.AddLayer(true)
	
func ClearButtons():
	for i in get_node("Panel/HBoxContainer/ScrollContainer/VBoxContainer").get_children():
		i.queue_free()
		
func resetButtons():
	var index = 0
	for i in get_node("Panel/HBoxContainer/ScrollContainer/VBoxContainer").get_children():
		i.text = str(index)
		index += 1
	

func _on_rmv_pressed():
	DrawingBoard.RemoveLayer()
