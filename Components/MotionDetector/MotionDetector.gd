extends TurretComponent

export var detect_range = 100
export var power_consumption = 10

func _ready():
	super()
	
func on_triggered():
	var area = get_node("Area")
	for body in area.get_overlapping_bodies():
		if body.is_in_group("Enemy"):
			trigger_outputs()
	
