class_name MapAreaGroup extends Node

var areas : Array[MapArea] = []
var cells : Array[MapCell] = [] # a flat list of all cells inside
var outline : PackedVector2Array = []
var in_out := MapAreas.InOut.EXTERIOR
var hedges_available : Array[Line] = []
var hedges_taken : Array[Line] = []
var objects = []

signal object_entered(o)
signal object_exited(o)

func count() -> int:
	return areas.size()

func on_object_entered(o) -> void:
	if not o.map_tracker.last_update_changed_area_group(): return
	objects.append(o)
	object_entered.emit(o)

func on_object_exited(o) -> void:
	if not o.map_tracker.last_update_changed_area_group(): return
	objects.erase(o)
	object_exited.emit(o)

func add_area(a:MapArea) -> void:
	areas.append(a)
	update_cells()
	a.group = self
	a.object_entered.connect(on_object_entered)
	a.object_exited.connect(on_object_exited)

func is_inside(a:MapArea) -> bool:
	return areas.has(a)

func is_cell_inside(c:MapCell) -> bool:
	for area in areas:
		if area.is_inside(c): return true
	return false

func is_interior() -> bool:
	return in_out == MapAreas.InOut.INTERIOR

func get_cells() -> Array[MapCell]:
	return cells.duplicate(false)

func update_cells() -> void:
	var arr:Array[MapCell] = []
	for a in areas:
		arr += a.cells
	cells = arr

func finalize(grid:MapGrid) -> void:
	outline = MapAreas.determine_outline(grid, get_cells())
	
	if is_interior():
		hedges_taken = []
		hedges_available = []
		
		# we don't want to remove hedges at the map edge, as those "openings" are useless to us
		var hedges_non_edge := []
		for i in range(outline.size()-1):
			var new_hedge := Line.new(outline[i], outline[i+1])
			if not grid.is_line_at_edge(new_hedge): hedges_non_edge.append(new_hedge)
			add_hedge(new_hedge)
		
		if not Global.config.interior_hedge_surround_auto:
			var num_left_standing := Global.config.interior_hedge_starting_num
			while hedges_taken.size() > num_left_standing:
				remove_hedge(hedges_taken.pick_random())
		
		else:
			var num_remove := Global.config.interior_hedge_remove_num
			for i in range(num_remove):
				var hedge : Line = hedges_non_edge.pop_front()
				remove_hedge(hedge)

func can_place_hedge() -> bool:
	return hedges_available.size() > 0

func add_hedge(h:Line) -> void:
	hedges_available.erase(h)
	hedges_taken.append(h)

func remove_hedge(h:Line) -> void:
	hedges_taken.erase(h)
	hedges_available.append(h)

func flood_fill(start_area:MapArea, grid:MapGrid) -> void:
	add_area(start_area)
	
	# keep growing until conditions met
	var keep_growing := true
	var min_area_size := Global.config.area_group_min_size
	var max_area_size := Global.config.area_group_max_size_bounds.rand_int()
	
	while keep_growing:
		keep_growing = count() < min_area_size or count() < max_area_size
		if not keep_growing: break
		
		var nbs := grid.get_random_neighbor_areas_of(self)
		if nbs.size() <= 0: break
		
		var nb_area : MapArea = nbs.pick_random()
		add_area(nb_area)
