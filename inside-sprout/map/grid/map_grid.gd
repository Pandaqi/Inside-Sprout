class_name MapGrid extends Node

const NB_OFFSETS = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]

# we use a 1D array because GDScript doesn't support typed multidimensional arrays :/
var grid : Array[MapCell] = []
var size : Vector2i

func create(new_size:Vector2i):
	size = new_size
	
	grid = []
	grid.resize(size.x*size.y)
	
	# create the cells
	for x in range(size.x):
		for y in range(size.y):
			var cur_pos = Vector2i(x,y)
			var c : MapCell = MapCell.new(cur_pos)
			var id = pos_to_grid_id(cur_pos)
			grid[id] = c
	
	# assign the neighbors
	for cell in grid:
		cell.nbs = get_neighbors_of(cell)

func get_neighbors_of(cell:MapCell) -> Array[MapCell]:
	var arr : Array[MapCell] = []
	for NB_OFF in NB_OFFSETS:
		var new_pos : Vector2i = cell.pos + NB_OFF
		if out_of_bounds(new_pos): continue
		arr.append(get_cell_at(new_pos))
	return arr

func get_cells() -> Array[MapCell]:
	return grid.duplicate(false)

func get_random_position_grid() -> Vector2i:
	return Vector2i(randi_range(0, size.x-1), randi_range(0, size.y-1))

func get_random_position(dist_edge := Vector2.ZERO) -> Vector2:
	var bds := get_bounds()
	return Vector2(
		randf() * (bds.size.x - 2*dist_edge.x) + dist_edge.x, 
		randf() * (bds.size.y - 2*dist_edge.y) + dist_edge.y
	)

func pos_to_grid_id(pos:Vector2i) -> int:
	return pos.x + pos.y * size.x

func grid_id_to_pos(id:int) -> Vector2i:
	return Vector2i(id % size.x, floor(id / float(size.x)))

func grid_pos_to_real_pos(grid_pos:Vector2i) -> Vector2:
	return grid_pos_float_to_real_pos(Vector2(grid_pos))

func grid_pos_float_to_real_pos(grid_pos:Vector2) -> Vector2:
	return Global.config.cell_size * grid_pos

func real_pos_to_grid_pos(real_pos:Vector2) -> Vector2i:
	return Vector2i(floor(real_pos.x / Global.config.cell_size), floor(real_pos.y / Global.config.cell_size))

func get_cell_at(grid_pos:Vector2i) -> MapCell:
	if out_of_bounds(grid_pos): return null
	return grid[pos_to_grid_id(grid_pos)]

func out_of_bounds(grid_pos:Vector2i) -> bool:
	return grid_pos.x < 0 or grid_pos.x >= size.x or grid_pos.y < 0 or grid_pos.y >= size.y

func get_random_neighbors_of(cells:Array[MapCell], have_no_area := false) -> Array[MapCell]:
	var nbs_valid : Array[MapCell] = []
	for cell in cells:
		for nb in cell.nbs:
			if cells.has(nb): continue # ignore those that are part of search, of course
			if have_no_area and nb.has_area(): continue
			nbs_valid.append(nb)
	nbs_valid.shuffle()
	return nbs_valid

func get_random_neighbor_areas_of(group:MapAreaGroup) -> Array[MapArea]:
	var nbs_valid : Array[MapArea] = []
	
	for cell in group.get_cells():
		for nb in cell.nbs:
			var new_area := nb.area
			if group.is_inside(new_area): continue
			if nbs_valid.has(new_area): continue
			nbs_valid.append(new_area)
	
	nbs_valid.shuffle()
	return nbs_valid

# @NOTE: everything is wound clockwise in this grid system
# So we can just pull the vector back 90 degrees to get it pointing to the center of OTHER cell (that didn't call this) => Then floor this to get grid index
func get_other_side_of_edge(l:Line) -> MapCell:
	var vec_ortho := l.vec.rotated(-0.5*PI)
	var pos := Vector2i( ( l.get_center() + 0.5*vec_ortho ).floor() )
	if out_of_bounds(pos): return null
	return get_cell_at(pos)

func get_bounds() -> Rect2:
	var cs := Global.config.cell_size
	return Rect2(0, 0, size.x*cs, size.y*cs)

func get_random_position_cells(include : Array[MapCell] = [], exclude : Array[MapCell] = []) -> Vector2:
	var cells := include.duplicate(false) if include.size() > 0 else get_cells()
	for cell in exclude:
		cells.erase(cell)
	if cells.size() <= 0: return Vector2.ZERO
	
	var rand_cell : MapCell = cells.pick_random()
	return grid_pos_float_to_real_pos(rand_cell.get_random_point_within())

func get_cell_dist_to_edge(cell:MapCell) -> int:
	var x_dist : int = min(cell.pos.x, size.x - 1 - cell.pos.x)
	var y_dist : int = min(cell.pos.y, size.y - 1 - cell.pos.y)
	return min(x_dist, y_dist)

func is_at_edge(pos:Vector2i) -> bool:
	return pos.x == 0 or pos.x == (size.x - 1) or pos.y == 0 or pos.y == (size.y - 1)

func is_line_at_edge(l:Line) -> bool:
	return is_at_edge(Vector2i(l.start)) or is_at_edge(Vector2i(l.end))
