extends TurretComponent

onready var Bullet = load("res://Components/Bullet/Bullet.tscn")

var initial_component
var outputs = []
var type = "Turret"
var direction = Vector2.RIGHT

var error = ""

func trigger(power, params = {}):
	var angle = 0
	
	var icon = $Visual/Block/Icon
			
	if params.has('target'):
		direction = position.direction_to(params.target)
		angle = position.angle_to_point(params.target)
		$Tween.interpolate_property(icon, "rotation_degrees", icon.rotation_degrees, rad2deg(angle) - 180, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()

		
	if state == States.ACTIVE:
		print(name + " gets power pulse")
		fire(power, direction, angle)
	else:
		print("Component " + name + " is not active but received a trigger event!")
	
func fire(power, direction, angle = 0):
	print("TURRET FIRED TO " + str(direction))
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	bullet.position = position #+ Vector2(32, 0) 
	bullet.rotation = angle
	bullet.fire(power, direction)
	$Sfx/Fire.play()
	
