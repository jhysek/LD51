extends Area2D

export var power = 50
var state = 1

func _ready():
	pass

func _on_Timer_timeout():
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("PowerConsumer"):
			consumer.trigger(power)
