extends Node2D

export var power = 50
onready var range_area = get_node("Range")

func _ready():
	pass

func _on_Timer_timeout():
	print("tick")
	for consumer in range_area.get_overlapping_bodies():
		print("-> " + consumer.name)
		if consumer.is_in_group("PowerConsumer"):
			consumer.trigger(power)
