extends Area2D

signal building_destroyed

export var hitpoints = 100
enum States {
	DISABLED = 0,
	ACTIVE = 1,
	ERROR = -1	
}

var state = States.ACTIVE
var id = name
var code

onready var turret
var power = 0
var game
var tactical_mode

func super():
	game = get_node("/root/Game")
	game.connect("tactical_mode_signal", self, 'switch_to_tactical')
	game.connect("defence_mode_signal", self, 'switch_to_defence')
	
func after_switch_to_tactical():
	pass
	
func after_switch_to_defence():
	pass
	
	
func switch_to_tactical():
	tactical_mode = true
	if has_node("Light2D"):
		$Light2D.texture_scale = 0.33
		$Light2D.energy = 1
	after_switch_to_tactical()
	
func switch_to_defence():
	tactical_mode = false
	if has_node("Light2D"):
		$Light2D.texture_scale = 0.01
		$Light2D.energy = 0
	
	after_switch_to_defence()

func on_triggered():
	pass
	
func trigger(input_power, params = null):
	power = input_power
	on_triggered()
	
func trigger_outputs(parameter = null):
	if game.paused:
		return
		
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("Enemy"):
			consumer.triggered_by_power_pulse(self)
		
		if consumer.is_in_group("PowerConsumer") and consumer != get_parent():
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
	
func destroy():
	emit_signal("building_destroyed")
	get_node("/root/Game").building_destroyed(code)
	hide()
	position = Vector2(-2000, -2000)
	$DestroyTimer.start()
	
func hit(hp, by = null):
	if hitpoints > 0:
		hitpoints = hitpoints - hp
		if (has_node("HealthBar")):
			$HealthBar.set_value(hitpoints)
		game.update_buildings_cost()
		print("Damage... HP: " + str(hitpoints))
		if hitpoints <= 0:
			#by.building_destroyed()
			destroy()

func _on_DestroyTimer_timeout():
	queue_free()
