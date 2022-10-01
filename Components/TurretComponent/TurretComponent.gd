extends Node2D

var id = name

onready var turret
var outputs = []
var power = 0

func super():
	turret = get_parent()
	outputs = turret.get_outputs_of(name)
	

func report():
	print("Component " + self.name + " is active.")

func on_triggered():
	pass
	
func trigger(input_power):
	print(name + " is TRIGGERED with power " + str(input_power))
	power = input_power
	on_triggered()
	
func trigger_outputs():
	print(name + " triggers it's ouputs..." + str(outputs))
	for output in outputs:
		output.trigger(power)

