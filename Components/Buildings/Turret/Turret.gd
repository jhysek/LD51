extends Node2D

enum States {
	ACTIVE,
	DISABLED,
	ERROR	
}

var initial_component
var outputs = []

var error = ""
var state = States.ACTIVE

var schema = {
	'input': '1x1',
	'1x1': {
		"type": "MotionDetector",
		"outputs": ['1x2']
	},
	'1x2': {
		"type": "MotionDetector",
		"outputs": []
	},
	'0x2': {
		"type": "Laser",
		"direction": Vector2(1,0)
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_component = get_node(schema["input"])
	if !initial_component:
		state = States.ERROR
		error = "Input component is not defined"
		return
		
	for child in get_children():
		if child.is_in_group("TurretComponent"):
			child.report()

func get_outputs_of(id):
	if schema.has(id):
		var result = []
		for node_name in schema[id].outputs:
			var child = get_node(node_name)
			if child:
				result.append(child)
		return result
	else:
		print("ERROR: query for non-existing component! ID: " + str(id))
		return []

func trigger(power):
	if state == States.ACTIVE:
		print(name + " gets power pulse")
		initial_component.trigger(power)
	else:
		print("Component " + name + " is not active but received a trigger event!")
	
	
