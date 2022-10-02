extends Area2D

enum States {
	WALK,
	ATTACK_WALK,
	ATTACK_SHOOT,
	ATTACK,
	DEAD
}
export var HP = 100
export var ATTACK = 10
export var SPEED = 50
export var SHOOTING = false

var path = []
var game_field
var game
var target 
var state = States.WALK
var attack_building
var exit_cell
var type
var config = {
	speed = SPEED,
	attack = ATTACK,
	hitpoints = HP,
	shooting = SHOOTING
}

func _ready():
	$HealthBar.setup(config.hitpoints)
	set_physics_process(true)

func set_type(new_type):
	if Components.enemies.has(new_type):
		config = Components.enemies[new_type]
		type = new_type

func _physics_process(delta):
	if state == States.ATTACK or state == States.DEAD:
		return
		
	if target:
		if position.distance_to(target) > game.CELL_SIZE.x / 20:
			position = position + position.direction_to(target) * config.speed * delta
		else:
			target = pop_next_target()
	else:
		if state == States.WALK:
			print("DONE")
			queue_free()
			#get_parent().get_node("Line").queue_free()
		
		if state == States.ATTACK_WALK:
			print("Setting state to ATTACK")
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
	print("Enemy knows that building was destroyed " + str(state))
	path = game.get_nearest_path(game_field.world_to_map(position), exit_cell)
	target = pop_next_target()
	print("enemy: Setting state to WALK")
	$WalkAgainTimer.start()
	attack_building = null
	$AttackTimer.stop()
	print("PATH: " + str(path))
	print("NEXT TARGET: " + str(target))

func triggered_by_power_pulse(from):
	if state == States.WALK:
		attack_building = from
		attack_building.connect("building_destroyed", self, "building_destroyed")
		print("Setting state to ATTACK_WALK")
		state = States.ATTACK_WALK
		var new_path = game.get_nearest_path(game_field.world_to_map(position), game_field.world_to_map(attack_building.position))
		path = new_path
		target = pop_next_target()
			
func _on_AttackTimer_timeout():
	if attack_building and state == States.ATTACK:
		if attack_building and attack_building.hitpoints > 0:
			attack_building.hit(config.attack, self)
			$AttackTimer.start()
		
func die():
	print("Setting state to DEAD")
	state = States.DEAD
	queue_free()
			
func hit(hp):
	config.hitpoints -= hp
	$HealthBar.set_value(config.hitpoints)
	print("ENEMY HIT.. HP left: " + str(config.hitpoints))
	if config.hitpoints <= 0:
		die()


func _on_WalkAgainTimer_timeout():
	state = States.WALK
	
