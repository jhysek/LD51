extends Node2D

func _ready():
	$Label.modulate = Color(1,1,1,0)
		
func say(message, options = {}):
	if options.has("color"):
		$Label.self_modulate = options.color
		
	if options.has("at"):
		position = options.at
		
	$Label.text = message
	$AnimationPlayer.play("Say")
