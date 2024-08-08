class_name MapHearts

var cells : Array[MapCell] = []

func place(grid:MapGrid, num:int, min_dist:float) -> void:
	var valid_cells := grid.get_cells()
	valid_cells.shuffle()
	
	for i in range(num):
		place_heart(valid_cells, min_dist)

func place_heart(valid_cells:Array[MapCell], min_dist) -> void:
	
	var cell : MapCell = valid_cells.pop_back()
	for i in range(valid_cells.size()-1,-1,-1):
		var dist := valid_cells[i].pos.distance_to(cell.pos)
		if dist > min_dist: continue
		valid_cells.remove_at(i)
	
	cells.append(cell)

func on_heart_died(h:Heart) -> void:
	for cell in cells:
		if cell.heart_node != h: continue
		cell.heart_node = null
		cells.erase(cell)
		break
	
	if cells.size() > 0: return
	GSignal.game_over.emit(false)
