extends TurretComponent


var initial_component
var outputs = []

var error = ""


func trigger(power, direction = null):
	print("TURRET IS TRIGGERED. Power: " + str(power) + " direction: " + str(direction) )
	if state == States.ACTIVE:
		print(name + " gets power pulse")
		fire(power, direction)
	else:
		print("Component " + name + " is not active but received a trigger event!")
	
func fire(power, direction):
	print("TURRET FIRED ")
	
