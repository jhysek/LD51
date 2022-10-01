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

var enemies = [
]

func _ready():
	set_process(true)
	set_process_input(true)
	
func start_tactics_mode():
	mode = GameModes.TACTICS
	$CanvasLayer/TacticsOveraly.show()
	$CanvasLayer/DefenceOverlay.show()
	generate_terrain()
	generate_enemy_waves(40)
	indicate_enemy_entrances()

func start_defence_mode():
	mode = GameModes.TACTICS
	$CanvasLayer/TacticsOveraly.show()
	$CanvasLayer/DefenceOverlay.show()

func generate_terrain():
	pass
	
func random_top_cell(field_rec):
	var tiles = []
	for x in range(field_rec.size.width):
		var coords = Vector2(field_rec.position.x + x, field_rec.position.y)
		var cell = game_field.get_cell_v(coords)
		if cell >= 0:
			tiles.append(coords)
			
	return tiles[randi() % tiles.size()]

func random_bottom_cell(field_rec):
	var tiles = []
	for x in range(field_rec.size.width):
		var coords = Vector2(field_rec.position.x + x, field_rec.position.y + field_rec.size.h)
		var cell = game_field.get_cell_v(coords)
		if cell >= 0:
			tiles.append(coords)
			
	return tiles[randi() % tiles.size()]
	
func random_right_cell(field_rec):
	var tiles = []
	for y in range(field_rec.size.height):
		var coords = Vector2(field_rec.position.x + field_rec.size.w, field_rec.position.y + y)
		var cell = game_field.get_cell_v(coords)
		if cell >= 0:
			tiles.append(coords)
	return tiles[randi() % tiles.size()]
	
func random_left_cell(field_rec):
	var tiles = []
	for y in range(field_rec.size.height):
		var coords = Vector2(field_rec.position.x, field_rec.position.y + y)
		var cell = game_field.get_cell_v(coords)
		if cell >= 0:
			tiles.append(coords)
	return tiles[randi() % tiles.size()]
	
func get_entry_cell(field_rec, direction):
	if direction == 0:
		return random_top_cell(field_rec)
	if direction == 1:
		return random_right_cell(field_rec)
	if direction == 2:
		return random_bottom_cell(field_rec)
	if direction == 3:
		return random_left_cell(field_rec)
	
func generate_enemy_waves(enemy_count):
	var delay = 0
	var field_rect = $GameField.get_used_rect()
	for enemy in range(enemy_count):
		delay = delay + randi() % 3000
		var direction = randi() % 4  # 0 - top, 1 - right, 2 - bottom, 3 - left
	
		enemies.push_back({
			time = delay,
			entry_cell = get_entry_cell(field_rect, direction)
		})
		
	print(enemies)
	return enemies
	
func indicate_enemy_entrances():
	pass
	
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
			
		if event is InputEventMouseButton and map_pos and event.pressed:
			if selected_building: 
				if !building_at(map_pos):
					place_building(map_pos)
					return
					
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
	selected_building = component
	for building in $CanvasLayer/TacticsOveraly/Buildings.get_children():
		building.select(component == building)

