extends Area2D

enum States {
	WALK,
	ATTACK_WALK,
	ATTACK,
	DEAD
}
export var hitpoints = 100
export var force = 10
export var SPEED = 50
var path = []
var game_field
var game
var target 
var state = States.WALK
var attack_building
var exit_cell


func _ready():
	$HealthBar.setup(hitpoints)
	set_physics_process(true)

func _physics_process(delta):
	if state == States.ATTACK || state == States.DEAD:
		return
		
	if target:
		if position.distance_to(target) > game.CELL_SIZE.x / 20:
			position = position + position.direction_to(target) * SPEED * delta
		else:
			target = pop_next_target()
	else:
		if state == States.WALK:
			print("DONE")
			queue_free()
			#get_parent().get_node("Line").queue_free()
		
		if state == States.ATTACK_WALK:
			state = States.ATTACK			
			$AttackTimer.start()
			
func pop_next_target():
	if path.size() > 0:
		var path_item = path[0]
		var next_target = game_field.map_to_world(Vector2(path_item.x, path_item.y)) + game.CELL_SIZE / 2
		path.remove(0)
		return next_target
	else:
		return null
		
func draw_path():
	var line = $Line
	remove_child(line)
	get_parent().add_child(line)
	for item in path:
		line.add_point(Vector2(game_field.map_to_world(Vector2(item.x, item.y))) + game.CELL_SIZE / 2)
	
func spawn(map_pos):
	game = get_node("/root/Game")
	game_field = get_parent()
	position = game_field.map_to_world(map_pos) + game.CELL_SIZE / 2
	draw_path()
	target = pop_next_target()

func building_destroyed():
	attack_building = null
	$AttackTimer.stop()
	path = game.get_nearest_path(game_field.world_to_map(position), exit_cell)
	target = pop_next_target()
	state = States.WALK

func _on_Enemy_area_entered(area):
	if state == States.WALK and area.is_in_group("PowerSource"):
		attack_building = area.building
		if attack_building:
			state = States.ATTACK_WALK
			var new_path = game.get_nearest_path(game_field.world_to_map(position), game_field.world_to_map(attack_building.position))
			path = new_path
			target = pop_next_target()
			
func _on_AttackTimer_timeout():
	if attack_building and state == States.ATTACK:
		attack_building.hit(force, self)
		
func die():
	state = States.DEAD
	queue_free()
			
func hit(hp):
	hitpoints -= hp
	$HealthBar.set_value(hitpoints)
	print("ENEMY HIT.. HP left: " + str(hitpoints))
	if hitpoints <= 0:
		die()
