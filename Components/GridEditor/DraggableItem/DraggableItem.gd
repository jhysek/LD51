extends Area2D

export var w = 2
export var h = 2
export var cell_size = 64 

var dragging = false
var drag_offset = Vector2(0,0)

signal dragsignal;

func _ready():
	$Visual/Panel.rect_size = Vector2(w * cell_size, h * cell_size)
	connect("dragsignal",self,"_set_drag_pc")
	
func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.global_position = Vector2(mousepos.x, mousepos.y) - drag_offset

func _set_drag_pc():
	dragging=!dragging

func _on_DraggableItem_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			drag_offset = event.get_position() - global_position
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.global_position = event.get_position()

