extends KinematicBody2D

export var SPEED = 2000


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

func _physics_process(delta):
	move_and_slide(Vector2(-1,0) * delta * SPEED)
