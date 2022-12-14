extends Area2D


var state = TurretComponent.States.DISABLED
onready var building = get_parent()

func _ready():
	pass # Replace with function body.

func change_state(value):
	state = value
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("Enemy"):
			consumer.triggered_by_power_pulse(building)
			
		if consumer.is_in_group("PowerConsumer") and consumer != get_parent():
			if consumer.type != "MotionDetector":
				consumer.refresh_power_connection()
