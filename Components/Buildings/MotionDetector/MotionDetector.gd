extends TurretComponent

export var detect_range = 100
export var power_consumption = 10
var building = self
var parameter
var type = "MotionDetector"

func _ready():
	hitpoints = Components.definitions[type].hitpoints
	$HealthBar.setup(hitpoints)
	switch_to_tactical()
	super()
	game = get_node("/root/Game")
	game.connect("tactical_mode_signal", self, 'switch_to_tactical')
	game.connect("defence_mode_signal", self, 'switch_to_defence')
	
func price():
	var price = Components.definitions[type].price 
	return round(price * (hitpoints / float(Components.definitions[type].hitpoints)))
	
func switch_to_tactical():
	tactical_mode = true
	$Light2D.texture_scale = 0.33
	$Light2D.energy = 1

	
func switch_to_defence():
	tactical_mode = false
	$Light2D.texture_scale = 0.01
	$Light2D.energy = 0
	
func on_power_change():
	$RadarArea.change_state(state)


func on_triggered():
	$Sfx/Pulse.play()
	$AnimationPlayer.play("PowerSourceImpulse")
	var radar_area = get_node("RadarArea")
	for area in radar_area.get_overlapping_areas():
		if area.is_in_group("Enemy"):
			trigger_outputs({
				target = area.position
			})

func trigger_outputs(input_parameter = null):
	parameter = input_parameter
	print("trigger_outputs")
	$DistributionDelay.start()
	
func _on_DistributionDelay_timeout():
	for consumer in $RadarArea.get_overlapping_areas():
		print("overlas with " + str(consumer))
		if consumer.is_in_group("Enemy"):
			consumer.triggered_by_power_pulse(self)
			
		if consumer.is_in_group("PowerConsumer") and consumer != self and consumer.type != "Battery":
			print("triggering -> " + consumer.name)
			consumer.trigger(power, parameter)


