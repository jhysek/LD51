extends Area2D

export var power = 100
var state = 1
var building = self
var hitpoints = 100
var code 
var type = "PowerSource"
var tactical_mode = true
var cooldown = 0

onready var game = get_node("/root/Game")

func _ready():
	$HealthBar.setup(hitpoints)
	$TimeoutProgress.value = 0
	$TimeoutProgress.max_value = 100
	set_process(true)
	game.connect("tactical_mode_signal", self, 'switch_to_tactical')
	game.connect("defence_mode_signal", self, 'switch_to_defence')
	
func switch_to_tactical():
	print("TACTICAL MODE")
	tactical_mode = true
	$TimeoutProgress.value = 0
	$Light2D.texture_scale = 0.33
	$Light2D.energy = 1
	
func switch_to_defence():
	print("DEFENCE MODE")
	$Timer.start()
	tactical_mode = false
	$TimeoutProgress.value = 0
	cooldown = 0
	$Light2D.texture_scale = 0.01
	$Light2D.energy = 0
	
func _process(delta):
	if !tactical_mode:
		cooldown += delta * 10
		$TimeoutProgress.value = round(cooldown)
	
func _on_Timer_timeout():
	if game.is_defence_mode():
		$TimeoutProgress.value = 0
		cooldown = 0
		$AnimationPlayer.play("Impulse")
		$DistributionDelay.start()
	else:
		print("TACTICAL MODE")

func destroy():
	print("BUILDING DESTROYED")
	get_node("/root/Game").building_destroyed(code)
	queue_free()
	
func hit(hp, by):
	hitpoints = hitpoints - hp
	$HealthBar.set_value(hitpoints)
	print("Damage... HP: " + str(hitpoints))
	if hitpoints <= 0:
		by.building_destroyed()
		destroy()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "Idle":
		$AnimationPlayer.play("Idle")


func _on_DistributionDelay_timeout():
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("PowerConsumer"):
			consumer.trigger(power)
