class_name MapAreas

enum InOut
{
	INTERIOR,
	EXTERIOR
}

var areas : Array[MapArea] = []
var area_groups : Array[MapAreaGroup] = []

func subdivide(grid:MapGrid) -> void:
	areas = []
	
	# while cells have no area yet
	var cells_to_do := grid.get_cells()
	while cells_to_do.size() > 0:
		# start a new one
		var area := MapArea.new()
		area.id = areas.size()
		areas.append(area)
		
		var new_cell : MapCell = cells_to_do.pop_back()
		
		area.flood_fill(new_cell, grid)
		
		for cell in area.get_cells():
			cells_to_do.erase(cell)
		
		area.finalize(grid)

func create_interior_around(cell:MapCell, grid:MapGrid):
	var start_area := cell.area
	var group := MapAreaGroup.new()
	group.in_out = InOut.INTERIOR
	group.flood_fill(start_area, grid)
	group.finalize(grid)
	area_groups.append(group)

func recolor(grid:MapGrid, ed:ElementData):
	for area in areas:
		area.reset_type()
	
	for area in areas:
		if area.is_interior(): 
			area.set_type(ed.type_interior)
			continue
		
		# assign a type
		# prefer types our neighbors don't have; but if that's not possible, just pick any
		var possible_types = ed.area_types.duplicate(false)
		var final_nbs := grid.get_random_neighbors_of(area.cells)
		for nb in final_nbs:
			if not nb.area: continue
			possible_types.erase(nb.area.type)
		
		var final_type : ElementType = ed.area_types.pick_random()
		if possible_types.size() > 0: final_type = possible_types.pick_random()
		
		print("Set area type", final_type)
		area.set_type(final_type)

static func determine_outline(grid:MapGrid, cells:Array[MapCell]) -> PackedVector2Array:
	
	# first collect a loose array of outer edges
	var outer_edges : Array[Line] = []
	for cell in cells:
		for cell_edge in cell.edges:
			var nb := grid.get_other_side_of_edge(cell_edge)
			if nb and cells.has(nb): continue
			outer_edges.append(cell_edge)
	
	# then sort them in clockwise order
	var first_edge : Line = outer_edges.pop_back()
	var edges_sorted : Array[Line] = [first_edge]
	var first_pos := first_edge.start
	var last_pos := first_edge.end
	
	while not last_pos.is_equal_approx(first_pos) and outer_edges.size() > 0:
		var next_index : int
		for i in range(outer_edges.size()):
			if not outer_edges[i].start.is_equal_approx(last_pos): continue
			next_index = i
			break
		
		var next_edge : Line = outer_edges.pop_at(next_index)
		edges_sorted.append(next_edge)
		last_pos = next_edge.end
	
	# @TODO @IMPROV: possible optimization is to combine edges in the same direction into one big line
	
	# finally, keep only their points 
	var outline : PackedVector2Array = [first_pos]
	for edge in edges_sorted:
		outline.append(edge.end)
	return outline
