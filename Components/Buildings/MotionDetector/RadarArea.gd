extends Area2D


var state = TurretComponent.States.DISABLED
var building = get_parent()

func _ready():
	pass # Replace with function body.

func change_state(value):
	state = value
	if state == 0:
		$Range.modulate = Color(1,1,1,0.1)
	else:
		$Range.modulate = Color(1,1,1,0.7)
		
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("PowerConsumer") and consumer != get_parent():
			if consumer.type != "MotionDetector":
				print("Refreshing connection of motion detector: " + str(consumer))
				consumer.refresh_power_connection()
