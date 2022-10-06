extends TurretComponent

var type = "LaserAbsorber"

func _ready():
	hitpoints = Components.definitions[type].hitpoints
	$HealthBar.setup(hitpoints)
	super()

func price():
	var price = Components.definitions[type].price 
	return round(price * (hitpoints / float(Components.definitions[type].hitpoints)))
	
func trigger_outputs(input_parameter = null):
	$AnimationPlayer.play("Impulse")
	$Sfx/Pulse.play()
	for consumer in $RangeArea.get_overlapping_areas():
		if consumer.is_in_group("Enemy"):
			consumer.triggered_by_power_pulse(self)
			
		if consumer.is_in_group("PowerConsumer") and consumer != self:
			consumer.trigger(power)

func _on_LaserAbsorber_area_entered(area):
	if area.is_in_group("Laser"):
		if area.power > 5:
			print("ABSORBER RECEIVED POWER: " + str(area.power))
			trigger(area.power - 5)
			$DistributionDelay.start()
			area.queue_free()


func _on_DistributionDelay_timeout():
	trigger_outputs()
