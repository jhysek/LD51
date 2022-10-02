extends Area2D

var SPEED = 2000
var direction = Vector2.RIGHT
var activated = false
var power
var originator = null

func _ready():

	z_index = 0
	set_physics_process(true)
	
func fire(fire_power, fire_direction = Vector2.RIGHT):
	power = fire_power
	direction = fire_direction 
	activated = true
	$Timer.start()
	
func _physics_process(delta):
	if activated:
		position += direction * SPEED * delta
		
func _on_Bullet_area_entered(area):
	if area.is_in_group("Enemy"):
		print("ENEMY HIT")
		activated = false
		area.hit(power)
		queue_free()
		
	if originator and area.is_in_group("Building"):
		area.hit(power)
		activated = false
		queue_free()
		
func _on_Timer_timeout():
	queue_free()
