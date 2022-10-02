extends Node2D

var selected = "01"

func _ready():
	Transition.openScene()
	$Balance.text = "Balance: " + str(Inventory.balance) + " credits"

func _on_Start_mission_pressed():
	print("SELECTED: " + str(selected))
	$Sfx/Click.play()
	Transition.switchTo("res://Scenes/Game.tscn")
	#get_tree().change_scene("res://Scenes/Game.tscn")	
	
func unselect_levels():
	for level in $Levels.get_children():
		level.select(false)

func set_selected(level):
	selected = level.name
