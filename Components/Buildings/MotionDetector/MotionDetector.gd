extends TurretComponent

export var detect_range = 100
export var power_consumption = 10

func _ready():
	super()
	
func on_power_change():
	$RadarArea.change_state(state)
	
func on_triggered():
	var area = get_node("RadarArea")
	for body in area.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			var direction = global_position.direction_to(body.global_position)
			print("enemy detected at " + str(direction))
			trigger_outputs(direction)
	
