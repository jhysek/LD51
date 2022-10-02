extends Area2D

onready var menu = get_node("/root/Levels")
export var selected = false
var locked = false

func _ready():
	select(selected)

func select(value):
	selected = value
	if selected:
		$Sfx/Click.play()
		$Sprite.modulate = Color(1, 0, 1, 1)
		menu.set_selected(self)
	else: 
		$Sprite.modulate = Color(1,1,1,1)

func _on_01_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		menu.unselect_levels()
		select(true)
		
