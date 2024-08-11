extends Resource
class_name MapData

var grid : MapGrid
var areas : MapAreas
var hearts : MapHearts

func get_bounds() -> Rect2:
	return grid.get_bounds()

func get_random_edge_position(forbid_top := false, forbid_bottom := false) -> Vector2:
	var horizontal_edge := randf() <= 0.5
	if (forbid_top and forbid_bottom): horizontal_edge = false
	
	var pos_grid := Vector2i.ZERO
	if horizontal_edge:
		pos_grid.x = floor( randf() * grid.size.x )
		if randf() <= 0.5 or forbid_top: pos_grid.y = grid.size.y
		if forbid_bottom: pos_grid.y = 0
	else:
		pos_grid.y = floor( randf() * grid.size.y )
		if randf() <= 0.5: pos_grid.x = grid.size.x
	
	var pos_real := grid.grid_pos_to_real_pos(pos_grid)
	return pos_real

func get_closest_heart_to(pos:Vector2) -> Heart:
	var best_dist := INF
	var best_heart : Heart = null
	for cell in hearts.cells:
		var real_pos := grid.grid_pos_to_real_pos(cell.pos)
		var dist := real_pos.distance_to(pos)
		if dist >= best_dist: continue
		best_dist = dist
		best_heart = cell.heart_node
	if not is_instance_valid(best_heart): return null
	return best_heart

func query_position(params:Dictionary = {}) -> Vector2:
	var bad_pos := true
	var pos : Vector2
	
	var avoid = params.avoid if ("avoid" in params) else []
	var min_dist : float = params.dist if ("dist" in params) else 0.0
	
	var cells_include = params.cells_include if ("cells_include" in params) else []
	var cells_exclude = params.cells_exclude if ("cells_exclude" in params) else []
	
	var cell_based : bool = cells_include.size() > 0 or cells_exclude.size() > 0
	var dist_edge : Vector2 = params.dist_edge if ("dist_edge" in params) else Vector2.ZERO
	
	var num_tries := 0
	var max_tries := 100
	
	while bad_pos:
		bad_pos = false
		num_tries += 1
		if num_tries > max_tries: break
		
		if cell_based:
			pos = grid.get_random_position_cells(cells_include, cells_exclude)
		else:
			pos = grid.get_random_position(dist_edge)
		
		for node in params.avoid:
			var dist := pos.distance_to(node.global_position)
			if dist > min_dist: continue
			bad_pos = true
			break
	
	return pos
	
