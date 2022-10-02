extends Area2D

var state = TurretComponent.States.ACTIVE
onready var building = get_parent()


func change_state(value):
	state = value
	if state == 0:
		$Range.modulate = Color(1,1,1,0.1)
	else:
		$Range.modulate = Color(1,1,1,0.7)
		
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("Enemy"):
			consumer.triggered_by_power_pulse(building)
			
		if consumer.is_in_group("PowerConsumer") and consumer != get_parent():
			if consumer.type != "MotionDetector" and consumer.type != "Battery":
				consumer.refresh_power_connection()
