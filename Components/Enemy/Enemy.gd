extends Area2D

var Bullet = load("res://Components/Bullet/Bullet.tscn")
var Toast = load("res://Components/Toast/Toast.tscn")

signal enemy_is_gone

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
var shoot_direction = Vector2(1,0)
var config = {
	speed = SPEED,
	attack = ATTACK,
	hitpoints = HP,
	shooting = SHOOTING,
	price = 50
}

func _ready():
	$HealthBar.setup(config.hitpoints)
	set_physics_process(true)

func setup(code):
	if code == "01" or code == "02" or code == "03":
		config = Components.enemies[code]
		$Visual/e01.hide()
		$Visual/e02.hide()
		$Visual/e03.hide()
		$Visual.get_node("e" + code).show()
		$HealthBar.setup(config.hitpoints)
			
func set_type(new_type):
	if Components.enemies.has(new_type):
		config = Components.enemies[new_type]
		type = new_type

func _physics_process(delta):
	if game.paused:
		return
		
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
			emit_signal("enemy_is_gone")
			queue_free()
		
		if state == States.ATTACK_WALK:
			print("Setting state to ATTACK")
			state = States.ATTACK			
			$AttackTimer.start()
			
func pop_next_target():
	if path.size() > 0:
		var path_item = path[0]
		var next_target = game_field.map_to_world(Vector2(path_item.x, path_item.y)) + game.CELL_SIZE / 2
		path.remove(0)
		
		if position.x - next_target.x > 0:
			$Visual.scale = Vector2(1,1)
		else:
			$Visual.scale = Vector2(-1,1)
				
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
	if game.paused:
		return
		
	if state == States.WALK:
		attack_building = from
		attack_building.connect("building_destroyed", self, "building_destroyed")
		if config.shooting:
			state = States.ATTACK
			shoot_direction = position.direction_to(attack_building.position)
			$AttackTimer.start()

		else:
			state = States.ATTACK_WALK
			var new_path = game.get_nearest_path(game_field.world_to_map(position), game_field.world_to_map(attack_building.position))
			path = new_path
			target = pop_next_target()
			
func _on_AttackTimer_timeout():
	if game.paused:
		$AttackTimer.start()
		return
		
	if attack_building and state == States.ATTACK:
		if attack_building and attack_building.hitpoints > 0:
			if config.shooting:
				fire()
			else:
				attack_building.hit(config.attack, self)
			$AttackTimer.start()

func fire():
	print("ENEMY FIRES AT " + str(shoot_direction))
	var bullet = Bullet.instance()
	game_field.add_child(bullet)
	bullet.position = position
	bullet.originator = self
	bullet.fire(config.attack, shoot_direction)
		
func die():
	print("Setting state to DEAD")
	var toast = Toast.instance()
	game_field.add_child(toast)
	game.earn(config.price)
	toast.say("+ " + str(config.price), { at = position })
	state = States.DEAD
	emit_signal("enemy_is_gone")
	queue_free()
			
func hit(hp):
	config.hitpoints -= hp
	$HealthBar.set_value(config.hitpoints)
	print("ENEMY HIT.. HP left: " + str(config.hitpoints))
	if config.hitpoints <= 0:
		die()

func _on_WalkAgainTimer_timeout():
	state = States.WALK
	
