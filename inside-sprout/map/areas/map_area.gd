class_name MapArea

var type : ElementType
var id := -1
var cells : Array[MapCell] = []
var outline_edges : Array[Line] = []
var outline : PackedVector2Array = []

func count() -> int:
	return cells.size()

func add_cell(c:MapCell) -> void:
	cells.append(c)
	c.area = self

func is_inside(c:MapCell) -> bool:
	return cells.has(c)

func finalize(grid:MapGrid) -> void:
	determine_outline(grid)

func determine_outline(grid:MapGrid):
	
	# first collect a loose array of outer edges
	var outer_edges : Array[Line] = []
	for cell in cells:
		for cell_edge in cell.edges:
			var nb := grid.get_other_side_of_edge(cell_edge)
			if nb and is_inside(nb): continue
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
	
	print("OUTER_EDGES_LEFT", outer_edges.size())
			
	# @TODO: possible optimization is to combine edges in the same direction into one big line
	
	
	
	# finally, keep only their points 
	outline_edges = edges_sorted
	outline = [first_pos]
	for edge in edges_sorted:
		outline.append(edge.end)
