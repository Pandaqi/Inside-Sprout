class_name MapHearts

var cells : Array[MapCell] = []

func place(grid:MapGrid, num:int, min_dist:float) -> void:
	var valid_cells := grid.get_cells()
	
	var min_dist_to_edge := Global.config.hearts_min_cells_to_edge
	for i in range(valid_cells.size()-1,-1,-1):
		var dist_to_edge := grid.get_cell_dist_to_edge(valid_cells[i])
		if dist_to_edge >= min_dist_to_edge: continue
		valid_cells.remove_at(i)
	
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

func get_base_health() -> float:
	return Global.config.heart_health * Global.config.enemy_damage_factor

func heal(factor:float) -> void:
	factor *= get_base_health()
	for cell in cells:
		cell.heart_node.health.change(+factor)
