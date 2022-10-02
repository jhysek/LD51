extends Node2D

var selected = "01"

func _ready():
	Transition.openScene()
	setup_levels()
	if Levels.default_level and $Levels.has_node(Levels.default_level):
		$Levels.get_node(Levels.default_level).select(true)
		
	$Balance.text = "Balance: " + str(Inventory.balance) + " credits"

func setup_levels():
	for level_node in $Levels.get_children():
		if Levels.all.has(level_node.name):
			print(str(level_node.name) + " > HAS LEVEL") 		
			if Levels.all[level_node.name].finished:
				level_node.finished()
		else:
			level_node.lock()
			
func _on_Start_mission_pressed():
	Levels.set_current_level(selected)
	$Sfx/Click.play()
	Transition.switchTo("res://Scenes/Game.tscn")
	
func unselect_levels():
	for level in $Levels.get_children():
		level.select(false)

func set_selected(level):
	selected = level.name
	var level_config = Levels.all[selected]
	$LevelInfo/Label.text = "Area " + str(level.name)
	$LevelInfo/Enemies.text = "Enemies: " + str(level_config.enemies)
	$LevelInfo/PowerSources.text = "Power sources: " + str(level_config.sources)
	
