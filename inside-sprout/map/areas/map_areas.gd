class_name MapAreas

var areas : Array[MapArea] = []

func subdivide(grid:MapGrid, ed:ElementData) -> void:
	var cells_to_do := grid.get_cells()
	
	areas = []
	
	# while cells have no area yet
	while cells_to_do.size() > 0:
		# start a new one
		var area := MapArea.new()
		area.id = areas.size()
		areas.append(area)
		
		var new_cell : MapCell = cells_to_do.pop_back()
		area.add_cell(new_cell)
		
		# keep growing until conditions met
		var keep_growing := true
		var min_area_size := Global.config.area_min_size
		var max_area_size := Global.config.area_max_size_bounds.rand_int()
		while keep_growing:
			var nbs := grid.get_random_neighbors_of(area.cells, true)
			if nbs.size() <= 0: break
			
			var nb : MapCell = nbs.pick_random()
			cells_to_do.erase(nb)
			area.add_cell(nb)
			keep_growing = area.count() < min_area_size or area.count() < max_area_size
		
		# assign a type
		# prefer types our neighbors don't have; but if that's not possible, just pick any
		var possible_types = ed.area_types.duplicate(false)
		var final_nbs := grid.get_random_neighbors_of(area.cells)
		for nb in final_nbs:
			if not nb.area: continue
			possible_types.erase(nb.area.type)
		
		var final_type : ElementType = ed.area_types.pick_random()
		if possible_types.size() > 0: final_type = possible_types.pick_random()
		
		area.type = final_type
		area.finalize(grid)
