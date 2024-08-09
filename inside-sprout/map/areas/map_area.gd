class_name MapArea

var type : ElementType
var id := -1
var cells : Array[MapCell] = []
# var outline_edges : Array[Line] = []
var outline : PackedVector2Array = []
var group : MapAreaGroup
var objects = []

signal object_entered(o)
signal object_exited(o)

func count() -> int:
	return cells.size()

func add_cell(c:MapCell) -> void:
	cells.append(c)
	c.area = self
	c.object_entered.connect(on_object_entered)
	c.object_exited.connect(on_object_exited)

func on_object_entered(o) -> void:
	if not o.map_tracker.last_update_changed_area(): return
	objects.append(o)
	object_entered.emit(o)

func on_object_exited(o) -> void:
	if not o.map_tracker.last_update_changed_area(): return
	objects.erase(o)
	object_exited.emit(o)

func get_cells() -> Array[MapCell]:
	return cells.duplicate(false)

func is_inside(c:MapCell) -> bool:
	return cells.has(c)

func is_interior() -> bool:
	if group and group.is_interior(): return true
	return false

func finalize(grid:MapGrid) -> void:
	outline = MapAreas.determine_outline(grid, cells)

func reset_type() -> void:
	type = null

func flood_fill(start_cell:MapCell, grid:MapGrid) -> void:
	add_cell(start_cell)
		
	# keep growing until conditions met
	var keep_growing := true
	var min_area_size := Global.config.area_min_size
	var max_area_size := Global.config.area_max_size_bounds.rand_int()
	while keep_growing:
		var nbs := grid.get_random_neighbors_of(get_cells(), true)
		if nbs.size() <= 0: break
		
		var nb : MapCell = nbs.pick_random()
		add_cell(nb)
		keep_growing = count() < min_area_size or count() < max_area_size
