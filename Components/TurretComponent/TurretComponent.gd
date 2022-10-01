extends Area2D

enum States {
	DISABLED = 0,
	ACTIVE = 1,
	ERROR = -1	
}

var state = States.ACTIVE
var id = name

onready var turret
var power = 0

func super():
	pass

func on_triggered():
	pass
	
func trigger(input_power):
	print(name + " is TRIGGERED with power " + str(input_power))
	power = input_power
	on_triggered()
	
func trigger_outputs(parameter = null):
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("PowerConsumer") and consumer != get_parent():
			print("triggering -> " + consumer.name)
			consumer.trigger(power, parameter)
			
func on_power_change():
	pass
	
func power_on():
	state = States.ACTIVE
	$Visual/Block/Icon.modulate = "ff00ff"
	on_power_change()
	
func power_off():
	state = States.DISABLED
	$Visual/Block/Icon.modulate = "b5ffffff"
	on_power_change()

func _on_Turret_area_entered(area):
	if area.get_parent() == self:
		return
		
	if area.is_in_group("PowerSource") and area.get_parent() != self and area.state != States.DISABLED:
		power_on()

func _on_Turret_area_exited(area):
	if area.is_in_group("PowerSource"):
		refresh_power_connection(area)

func refresh_power_connection(removed_area = null):
	for area in get_overlapping_areas():
		if area != removed_area and area.is_in_group("PowerSource") and area.get_parent() != self and area.state != States.DISABLED:
			power_on()
			return
	power_off()
	
