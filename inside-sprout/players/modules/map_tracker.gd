class_name ModuleMapTracker extends Node2D

@onready var entity = get_parent()
@export var map_data : MapData
@export var element_data : ElementData
@export var static_object := false
@export var prog_data : ProgressionData
@export var is_player := false
var prev_cell : MapCell = null
var cur_cell : MapCell = null
var in_out := MapAreas.InOut.EXTERIOR

signal switched_in_out(new_state:MapAreas.InOut)

func activate() -> void:
	if static_object: refresh()
	self.switched_in_out.connect(on_switched_in_out)

func _process(_dt:float) -> void:
	if static_object: return
	refresh()

func refresh() -> void:
	update_current_cell()
	update_in_out()

func update_current_cell() -> void:
	prev_cell = cur_cell
	var new_cell := map_data.grid.get_cell_at( map_data.grid.real_pos_to_grid_pos(global_position) )
	if not new_cell: return # something went wrong and we should not update our cell now
	cur_cell = new_cell
	
	var cell_changed := prev_cell != cur_cell
	if cell_changed:
		if prev_cell: prev_cell.remove_object(entity)
		cur_cell.add_object(entity)

func last_update_changed_area() -> bool:
	if not prev_cell or not cur_cell: return true
	return prev_cell.area != cur_cell.area

func last_update_changed_area_group() -> bool:
	if not prev_cell or not cur_cell: return true
	return prev_cell.area.group != cur_cell.area.group

func update_in_out() -> void:
	var is_int := get_area().is_interior()
	var new_in_out := MapAreas.InOut.INTERIOR if is_int else MapAreas.InOut.EXTERIOR
	if new_in_out == in_out: return
	in_out = new_in_out
	switched_in_out.emit(in_out)

func on_switched_in_out(_v) -> void:
	if is_player and get_rules().recolor_upon_entry:
		map_data.areas.recolor(map_data.grid, element_data)

func get_area() -> MapArea:
	return cur_cell.area

func get_area_group() -> MapAreaGroup:
	return get_area().group

func is_interior() -> bool:
	return in_out == MapAreas.InOut.INTERIOR

func get_rules() -> Ruleset:
	return prog_data.get_rules(entity)
