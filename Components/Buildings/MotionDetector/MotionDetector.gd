extends TurretComponent

export var detect_range = 100
export var power_consumption = 10
var building = self
var parameter

func _ready():
	super()
	
func on_power_change():
	$RadarArea.change_state(state)

func trigger_outputs(input_parameter = null):
	parameter = input_parameter
	print("trigger_outputs")
	$DistributionDelay.start()
	
func on_triggered():
	$AnimationPlayer.play("PowerSourceImpulse")
	var radar_area = get_node("RadarArea")
	for area in radar_area.get_overlapping_areas():
		if area.is_in_group("Enemy"):
			trigger_outputs({
				target = area.position
			})

func _on_DistributionDelay_timeout():
	for consumer in $RadarArea.get_overlapping_areas():
		print("overlas with " + str(consumer))
		if consumer.is_in_group("PowerConsumer") and consumer != self:
			print("triggering -> " + consumer.name)
			consumer.trigger(power, parameter)
