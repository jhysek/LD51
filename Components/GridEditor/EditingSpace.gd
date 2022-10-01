extends TileMap

func clear():
	var rect = get_used_rect()
	for x in range(rect.size.x):
		for y in range(rect.size.y):
			set_cell(rect.position.x + x, rect.position.y, 0)
		
func update_visual(w, h, grid):
	clear()
	for x in range(w):
		for y in range(h):
			set_cell(w, h, grid[w][h])
