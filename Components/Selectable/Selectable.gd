extends Area2D

export var component_code = ""
export var price = 500

onready var game = get_node("/root/Game")
onready var detail = get_node("/root/Game/CanvasLayer/TacticsOverlay/Control/BuildingDetail")
var selected = false
var config

func _ready():
	
	print("DETAIL: " + str(detail))
	config = Components.definitions[component_code]
	price = config.price

func select(is_selected):
	selected = is_selected
	if selected: 
		$Visual.scale = Vector2(1.8, 1.8)
		detail.get_node("Title").text = config.name
		detail.get_node("Price").text = str(config.price) + " Cred"
		detail.get_node("Description").text = config.description
		#detail.show()
	else:
		$Visual.scale = Vector2(1, 1)
		#detail.hide()
	
		

func _on_Selectable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		game.selected_component(self)
