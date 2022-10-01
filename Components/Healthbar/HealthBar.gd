extends ProgressBar

func setup(maximum, new_value = null):
	max_value = maximum
	value = maximum
	
	if new_value:
		value = new_value
		
	if value == maximum:
		hide()
	
func set_value(new_value):
	value = 	 min(max(0, new_value), max_value)
	if value < max_value:
		show()
	else:
		hide()
		
func decrease(points):
	show()
	value = max(0, value - points)
