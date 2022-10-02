extends TurretComponent

var type = "LaserAbsorber"

func _ready():
	hitpoints = Components.definitions[type].hitpoints
	$HealthBar.setup(hitpoints)
	super()
		
func trigger_outputs(input_parameter = null):
	$AnimationPlayer.play("Impulse")
	for consumer in $RangeArea.get_overlapping_areas():
		if consumer.is_in_group("Enemy"):
			consumer.triggered_by_power_pulse(self)
			
		if consumer.is_in_group("PowerConsumer") and consumer != self:
			consumer.trigger(power)

func _on_LaserAbsorber_area_entered(area):
	if area.is_in_group("Laser"):
		trigger(area.power - 5)
		trigger_outputs()
		area.queue_free()
