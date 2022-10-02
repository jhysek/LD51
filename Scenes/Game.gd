extends Node2D

signal tactical_mode_signal
signal defence_mode_signal

onready var Enemy = load("res://Components/Enemy/Enemy.tscn")
onready var game_field = $GameField
onready var cursor = $GameField/Cursor

const CELL_SIZE = Vector2(64, 48)
const map_size = Vector2(14,7)

enum GameModes {
	TACTICS,
	DEFENCE
}

var mode = GameModes.TACTICS
var selected_building = null
var map_pos = null
var building_placement = {}
var traversing_graph = null
var current_time = 0
var paused = false
var config = {}
var enemies = []

func _ready():
	config = Levels.current_level()
	Transition.openScene()
	randomize()
	set_process(true)
	set_process_input(true)
	start_tactics_mode()
	
func start_tactics_mode():
	mode = GameModes.TACTICS
	$CanvasLayer/TacticsOverlay.show()
	$CanvasLayer/DefenceOverlay.hide()
	generate_terrain()
	generate_graph()
	generate_enemy_waves(1)
	indicate_enemy_entrances()
	emit_signal("tactical_mode_signal")

func start_defence_mode():
	mode = GameModes.DEFENCE
	$CanvasLayer/DefenceOverlay/AbortMenu.hide()
	current_time = 0
	$CanvasLayer/TacticsOverlay.hide()
	$CanvasLayer/DefenceOverlay.show()
	update_buildings_cost()
	emit_signal("defence_mode_signal")
	
func abort_mission():
	if mode == GameModes.DEFENCE:
		paused = true
		$CanvasLayer/DefenceOverlay/AbortMenu/Label.text = "Remaining equipment will be sold for: " + str(get_remaining_cost()) + " credits"
		$CanvasLayer/DefenceOverlay/AbortMenu.show()

func get_remaining_cost():
	var result = 0
	for key in building_placement.keys():
		var building = building_placement[key]
		print(str(building) + " = " + str(building.price()))
		result += building.price()
	return result
	
func update_buildings_cost():
	var result = get_remaining_cost()
	$CanvasLayer/DefenceOverlay/Remaining.text = "Remaining equipment cost: " + str(result) + " credits"
	
func is_defence_mode():
	return mode == GameModes.DEFENCE
	
func is_tactical_mode():
	return mode == GameModes.TACTICS

func generate_terrain():
	# TODO: Random holes
	
	# TODO: Random power sources
	
	pass
	
func accessible_cell(cell_code):
	return cell_code >= 0
	
func map_pos_code(map_pos):
	return str(map_pos.x) + "x" + str(map_pos.y)
	
func get_cell_id(x, y):
  return x * map_size.x + y
	
func generate_graph():
	if !traversing_graph:
		traversing_graph = AStar.new()
	else:
		traversing_graph.clear()

  # Add nodes
	for x in range(map_size.x):
		for y in range(map_size.y):
			if accessible_cell(game_field.get_cell(x, y)):
				traversing_graph.add_point(get_cell_id(x, y), Vector3(x, y, 0))

  # Add connections
	for x in range(map_size.x):
		for y in range(map_size.y):
			var cell_id = get_cell_id(x, y)
			if traversing_graph.has_point(cell_id):
				# get neighbours
				if accessible_cell(game_field.get_cell(x + 1, y)):
					traversing_graph.connect_points(cell_id, get_cell_id(x+1, y))
				if accessible_cell(game_field.get_cell(x, y + 1)):
					traversing_graph.connect_points(cell_id, get_cell_id(x, y + 1))
				if accessible_cell(game_field.get_cell(x - 1, y)):
					traversing_graph.connect_points(cell_id, get_cell_id(x-1, y))
				if accessible_cell(game_field.get_cell(x, y - 1)):
					traversing_graph.connect_points(cell_id, get_cell_id(x, y - 1))
		
func get_nearest_path(from, to):
	print("gettin path from " + str(from) + " to " + str(to))
	return traversing_graph.get_point_path(get_cell_id(from.x, from.y), get_cell_id(to.x, to.y))
	
func random_top_cell(field_rec):
	var tiles = []
	for x in range(field_rec.size.x):
		var coords = Vector2(field_rec.position.x + x, field_rec.position.y)
		var cell = game_field.get_cellv(coords)
		if cell >= 0:
			tiles.append(coords)
			
	if tiles.size() > 0:
		return tiles[randi() % tiles.size()]

func random_bottom_cell(field_rec):
	var tiles = []
	for x in range(field_rec.size.x):
		var coords = Vector2(field_rec.position.x + x, field_rec.position.y + field_rec.size.y - 1)
		var cell = game_field.get_cellv(coords)
		if cell >= 0:
			tiles.append(coords)
			
	if tiles.size() > 0:
		return tiles[randi() % tiles.size()]
	return null
	
func random_right_cell(field_rec):
	var tiles = []
	for y in range(field_rec.size.y):
		var coords = Vector2(field_rec.position.x + field_rec.size.x - 1, field_rec.position.y + y)
		var cell = game_field.get_cellv(coords)
		if cell >= 0:
			tiles.append(coords)
	if tiles.size() > 0:
		return tiles[randi() % tiles.size()]
	
func random_left_cell(field_rec):
	var tiles = []
	for y in range(field_rec.size.y):
		var coords = Vector2(field_rec.position.x, field_rec.position.y + y)
		var cell = game_field.get_cellv(coords)
		if cell >= 0:
			tiles.append(coords)
			
	if tiles.size() > 0:
		return tiles[randi() % tiles.size()]
	
func get_entry_cell(field_rec, direction):
	match direction:
		0: return random_top_cell(field_rec)
		1: return random_right_cell(field_rec)
		2: return random_bottom_cell(field_rec)
		3: return random_left_cell(field_rec)

func get_exit_cell(field_rec, entry_cell, direction):
	match direction:
		0: return entry_cell + Vector2(0, field_rec.size.y - 1)
		1: return entry_cell - Vector2(field_rec.size.x - 1, 0)
		2: return entry_cell - Vector2(0, field_rec.size.y - 1)
		3: return entry_cell + Vector2(field_rec.size.x - 1, 0)
	
func generate_enemy_waves(enemy_count):	
	var delay = 0
	var field_rect = $GameField.get_used_rect()
	for enemy in range(enemy_count):
		delay = delay + randi() % 3000 / 1000
		var direction = randi() % 4  # 0 - top, 1 - right, 2 - bottom, 3 - left
		var entry_cell = get_entry_cell(field_rect, direction)
		var exit_cell = get_exit_cell(field_rect, entry_cell, direction)
		
		if entry_cell:
			enemies.push_back({
				time = delay,
				direction = direction,
				entry_cell = entry_cell,
				exit_cell = exit_cell
			})
	return enemies
	
func indicate_enemy_entrances():
	var Arrow = load("res://Components/Arrow/Arrow.tscn")
	for enemy in enemies:
		var arrow = Arrow.instance()
		game_field.add_child(arrow)
		arrow.place(enemy.direction, game_field.map_to_world(enemy.entry_cell), CELL_SIZE)
		
	
func _input(event):
	if mode == GameModes.TACTICS:
		if event is InputEventMouse:
			var mouse_pos = event.position
			map_pos = game_field.world_to_map(mouse_pos - game_field.global_position)
			cursor.position = game_field.map_to_world(map_pos) + Vector2(32, 24)
			var selected_cell = game_field.get_cell(map_pos.x, map_pos.y)
	
			if selected_cell >= 0:
				cursor.visible = true
				if selected_building:
					var cell = game_field.get_cellv(map_pos)
					if can_be_placed(selected_building.component_code, cell):
						cursor.modulate = "#ffffff"
					else:
						cursor.modulate = "#B80C09"
				else:
					cursor.modulate = "#ffffff"
						
			else:
				map_pos = null
				cursor.visible = false	
			
		if event is InputEventMouseButton and map_pos and event.pressed:
			if selected_building: 
				if !building_at(map_pos):
					if !can_afford_building(selected_building):
						$GameField/Toast.say("Not enough money.", { 
							at = $GameField/Cursor.position - Vector2(0, CELL_SIZE.x)
						})
						return
					
					place_building(map_pos)
					return
					
			if building_at(map_pos):
				remove_building(map_pos)

func can_afford_building(selected_building):
	return selected_building.price <= Inventory.balance

func building_at(map_pos):
	if building_placement.has(map_pos_code(map_pos)):
		return  building_placement[map_pos_code(map_pos)]
	return null
	
func can_be_placed(component, cell):
	if component == "PowerSource" && cell != 1:
		return false
	return true
	
func place_building(map_pos):
	if selected_building and !building_at(map_pos):
		var cell = game_field.get_cellv(map_pos)
		if can_be_placed(selected_building.component_code, cell):
			$Sfx/Put.play()
			var Component = load("res://Components/Buildings/" + selected_building.component_code + "/" + selected_building.component_code + ".tscn")
			var component = Component.instance()
			component.code = map_pos_code(map_pos)
			component.type = selected_building.component_code
			game_field.add_child(component)
			component.position = game_field.map_to_world(map_pos) + CELL_SIZE / 2
			building_placement[map_pos_code(map_pos)] = component
			update_balance(Inventory.balance - selected_building.price)
		else:
			print("CANNOT BE PLACED THERE")

func earn(value):
	update_balance(Inventory.balance + value)
	
func update_balance(new_balance):
	Inventory.balance = new_balance
	$CanvasLayer/TacticsOverlay/Control/Balance.text = "Balance: " + str(new_balance) + " credits"
	$CanvasLayer/DefenceOverlay/Balance.text = "Balance: " + str(new_balance) + " credits"

func remove_building(map_pos):
	var building = building_at(map_pos)
	if building:
		$Sfx/Remove.play()
		update_balance(Inventory.balance + Components.definitions[building.type].price)
		building.queue_free()
		building_placement.erase(map_pos_code(map_pos))
	
func building_destroyed(code):
	building_placement.erase(code)
	
func _process(delta):
	if mode == GameModes.DEFENCE and !paused:
		current_time = current_time + delta
		if enemies.size() > 0:
			if enemies.size() > 0 and current_time > enemies[0].time:
				release_enemy()

func end_of_round():
	print("END")
	start_tactics_mode()

func release_enemy():
	var enemy_config = enemies.pop_front()
	var enemy = Enemy.instance()
	enemy.setup("03")
	game_field.add_child(enemy)
	enemy.path = get_nearest_path(enemy_config.entry_cell, enemy_config.exit_cell)
	enemy.exit_cell = enemy_config.exit_cell
	enemy.spawn(enemy_config.entry_cell)

func selected_component(component):
	selected_building = component
	$Sfx/Select.play()
	for building in $CanvasLayer/TacticsOverlay/Control/Buildings.get_children():
		building.select(component == building)


func _on_Button_pressed():
	start_defence_mode()

func _on_Abort_pressed():
	abort_mission()

func _on_Resume_pressed():
	paused = false
	$CanvasLayer/DefenceOverlay/AbortMenu.hide()

func _on_mision_aboard():
	update_balance(Inventory.balance + get_remaining_cost())
	get_tree().change_scene("res://Scenes/Levels.tscn")
