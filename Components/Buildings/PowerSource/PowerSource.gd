extends Area2D

signal building_destroyed

const MINE_QUANTITY = 500

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
	
func price():
	var price = Components.definitions[type].price 
	return round(price * (hitpoints / float(Components.definitions[type].hitpoints)))
	
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
	$Sfx/Brum.play()
	
func _process(delta):
	if !tactical_mode and state == 1:
		cooldown += delta * 10
		$TimeoutProgress.value = round(cooldown)
	
func _on_Timer_timeout():
	if game.is_defence_mode():
		$TimeoutProgress.value = 0
		cooldown = 0
		game.mine(MINE_QUANTITY)
		$AnimationPlayer.play("Impulse")
		$Sfx/Pulse.play()
		$DistributionDelay.start()
	else:
		print("TACTICAL MODE")

func destroy():
	$Sfx/Brum.stop()
	$Sfx/Destroyed.play()
	$Timer.stop()
	emit_signal("building_destroyed")
	get_node("/root/Game").building_destroyed(code)
	state = 0
	hide()
	position = Vector2(-2000, -2000)
	$DestroyTimer.start()
	
func hit(hp, by = null):
	if hitpoints > 0:
		hitpoints = hitpoints - hp
		game.update_buildings_cost()
		$HealthBar.set_value(hitpoints)
		print("Damage... HP: " + str(hitpoints))
		if hitpoints <= 0:
			destroy()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "Idle":
		$AnimationPlayer.play("Idle")


func _on_DistributionDelay_timeout():
	for consumer in get_overlapping_areas():
		if consumer.is_in_group("Enemy"):
			consumer.triggered_by_power_pulse(self)
			
		if consumer.is_in_group("PowerConsumer"):
			consumer.trigger(power)

func _on_DestroyTimer_timeout():
	queue_free()


func _on_PowerSource_area_entered(area):
	if area.is_in_group("Enemy"):
		area.triggered_by_power_pulse(self)
