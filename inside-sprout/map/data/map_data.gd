extends Resource
class_name MapData

var grid : MapGrid
var areas : MapAreas
var hearts : MapHearts

func get_bounds() -> Rect2:
	return grid.get_bounds()

func get_random_edge_position() -> Vector2:
	var horizontal_edge := randf() <= 0.5
	var pos_grid := Vector2i.ZERO
	if horizontal_edge:
		pos_grid.x = floor( randf() * grid.size.x )
		if randf() <= 0.5: pos_grid.y = grid.size.y
	else:
		pos_grid.y = floor( randf() * grid.size.y )
		if randf() <= 0.5: pos_grid.x = grid.size.x
	
	var pos_real := grid.grid_pos_to_real_pos(pos_grid)
	return pos_real

func get_closest_heart_to(pos:Vector2) -> Heart:
	var best_dist := INF
	var best_heart : Heart
	for cell in hearts.cells:
		var real_pos := grid.grid_pos_to_real_pos(cell.pos)
		var dist := real_pos.distance_to(pos)
		if dist >= best_dist: continue
		best_dist = dist
		best_heart = cell.heart_node
	return best_heart

func query_position(params:Dictionary = {}) -> Vector2:
	var bad_pos := true
	var pos : Vector2
	
	var avoid = params.avoid if ("avoid" in params) else []
	var min_dist : float = params.dist if ("dist" in params) else 0.0
	
	while bad_pos:
		bad_pos = false
		pos = grid.get_random_position()
		
		for node in params.avoid:
			var dist := pos.distance_to(node.global_position)
			if dist > min_dist: continue
			bad_pos = true
			break
	
	return pos
	
