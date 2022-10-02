extends TurretComponent

onready var max_capacity = 500
onready var current_capacity = 250
var type = "Battery"

onready var building = self

func _ready():
	$TimeoutProgress.max_value = max_capacity
	$TimeoutProgress.value = current_capacity
	hitpoints = Components.definitions[type].hitpoints
	$HealthBar.setup(hitpoints)
	super()
	
func price():
	var price = Components.definitions[type].price 
	return round(price * (hitpoints / float(Components.definitions[type].hitpoints)))
	
func on_triggered():
	current_capacity = min(max_capacity, current_capacity + power)
	$TimeoutProgress.value = current_capacity
	
func on_power_changed():
	for consumer in $RangeArea.get_overlapping_areas():
		if consumer.is_in_group("PowerConsumer") and consumer != self:
			consumer.refresh_power_changed()
	
func _on_Timer_timeout():
	if game.paused:
		return
		
	if current_capacity > 5:
		current_capacity = max(0, min(max_capacity, current_capacity - 5))
		if current_capacity > 0:
			power_on()
		else: 
			power_off()
		$TimeoutProgress.value = round(current_capacity)
		$AnimationPlayer.play("Impulse")
		$Sfx/Pulse.play()
		trigger_outputs(power)
	
func after_switch_to_tactical():
	$Timer.stop()
	
func after_switch_to_defence():
	print("BATTERY => defence")
	$Timer.start()
	
func trigger_outputs(input_parameter = null):
	print("trigger_outputs")
	$DistributionDelay.start()

func decrease_capacity(by):
	current_capacity = max(0, min(max_capacity, current_capacity - by))
	print(current_capacity)
	if current_capacity > 0:
		power_on()
	else: 
		power_off()
	$TimeoutProgress.value = round(current_capacity)
	$AnimationPlayer.play("Impulse")
	
	
func _on_DistributionDelay_timeout():
	print("BATTERY TIMEOUT")
	for consumer in $RangeArea.get_overlapping_areas():
		if consumer.is_in_group("Enemy"):
			consumer.triggered_by_power_pulse(self)
			
		print("overlas with " + str(consumer))
		if consumer.is_in_group("PowerConsumer") and consumer != self:
			print("triggering -> " + consumer.name)
			decrease_capacity(20)
			consumer.trigger(20)
