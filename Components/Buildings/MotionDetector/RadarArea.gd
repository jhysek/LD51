extends Area2D


var state = TurretComponent.States.DISABLED

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_state(value):
	state = value
	if state == 0:
		$Range.modulate = "ffffff"
	else:
		$Range.modulate = "ff0000"
		
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("PowerConsumer") and consumer != get_parent():
			print("Refreshing connection of motion detector: " + str(consumer))
			consumer.refresh_power_connection()
