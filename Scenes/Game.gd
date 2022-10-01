extends Node2D

onready var game_field = $GameField
onready var cursor = $GameField/Cursor

const CELL_SIZE = Vector2(64, 48)

enum GameModes {
	TACTICS,
	DEFENCE
}

var mode = GameModes.TACTICS
var selected_building = null
var map_pos = null
var building_placement = {}

func _ready():
	set_process(true)
	set_process_input(true)
	
func start_tactics_mode():
	mode = GameModes.TACTICS
	$CanvasLayer/TacticsOveraly.show()
	$CanvasLayer/DefenceOverlay.show()

func start_defence_mode():
	mode = GameModes.TACTICS
	$CanvasLayer/TacticsOveraly.show()
	$CanvasLayer/DefenceOverlay.show()

func _input(event):
	if mode == GameModes.TACTICS:
		if event is InputEventMouse:
			var mouse_pos = event.position
			map_pos = game_field.world_to_map(mouse_pos - game_field.global_position)
			cursor.position = game_field.map_to_world(map_pos) + Vector2(32, 24)
			var selected_cell = game_field.get_cell(map_pos.x, map_pos.y)
	
			if selected_cell >= 0:
				cursor.visible = true
			else:
				map_pos = null
				cursor.visible = false	
			
		if event is InputEventMouseButton and map_pos:
			if selected_building: 
				if !building_at(map_pos):
					place_building(map_pos)
				else:
					print("CANNOT PUT BUILDING THERE")
			
			if building_at(map_pos):
				remove_building(map_pos)

func map_pos_code(map_pos):
	return str(map_pos.x) + "x" + str(map_pos.y)
	
func building_at(map_pos):
	if building_placement.has(map_pos_code(map_pos)):
		return  building_placement[map_pos_code(map_pos)]
	return null
	
func place_building(map_pos):
	if selected_building and !building_at(map_pos):
		print("res://Components/Buildings/" + selected_building.component_code)
		var Component = load("res://Components/Buildings/" + selected_building.component_code + "/" + selected_building.component_code + ".tscn")
		var component = Component.instance()
		game_field.add_child(component)
		component.position = game_field.map_to_world(map_pos) + CELL_SIZE / 2
		building_placement[map_pos_code(map_pos)] = component
	
func remove_building(map_pos):
	var building = building_at(map_pos)
	if building:
		building.queue_free()
		building_placement.erase(map_pos_code(map_pos))
	
func _process(delta):
	pass

func selected_component(component):
	print("Building selected: ", component)
	selected_building = component
	for building in $CanvasLayer/TacticsOveraly/Buildings.get_children():
		building.select(component == building)

