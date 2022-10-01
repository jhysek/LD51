extends Area2D

export var component_code = ""

onready var game = get_node("/root/Game")
var selected = false


func _ready():
	pass # Replace with function body.

func select(is_selected):
	selected = is_selected
	if selected: 
		$Visual.scale = Vector2(1.8, 1.8)
	else:
		$Visual.scale = Vector2(1, 1)
		

func _on_Selectable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		game.selected_component(self)
