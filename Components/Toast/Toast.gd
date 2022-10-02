extends Node2D

const colors = {
	"yellow": Color("ffb922"),
	"red": Color("ff2222")
}

func _ready():
	$Label.modulate = Color(1,1,1,0)
		
func say(message, options = null):
	if !options:
		options = {}
		
	print("OPTS: " + str(options))
		
	if options.has("color"):
		$Label.self_modulate = colors[options.color] #options.color
		
	if options.has("at"):
		position = options.at
		
	if options.has("speed"):
		$AnimationPlayer.playback_speed = options.speed
		
	$Label.text = message
	$AnimationPlayer.play("Say")
