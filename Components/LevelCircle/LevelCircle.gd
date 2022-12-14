extends Area2D

onready var menu = get_node("/root/LevelMenu")
export var selected = false
var locked = false
var finished = false

func _ready():
	select(selected)

func lock():
	locked = true
	$Sprite.modulate = Color(1,1,1,0.1)
	$Lock.show()

func unlock():
	locked = false
	$Lock.hide()
	if finished:
		$Sprite.modulate = Color(0,1,0,1)
	else:
		$Sprite.modulate = Color(1,1,1,1)

func finished():
	finished = true
	if !selected:
		$Sprite.modulate = Color(0,1,0,1)

func select(value):
	if locked:
		return
		
	selected = value
	if selected:
		menu.unselect_levels()

		$Sprite.modulate = Color(1, 0, 1, 1)
		menu.set_selected(self)
	else: 
		if finished:
			$Sprite.modulate = Color(0,1,0,1)
		else:
			$Sprite.modulate = Color(1,1,1,1)

func _on_01_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if locked:
			$Sfx/Nono.play()
		else:
			$Sfx/Click.play()
		select(true)
		
