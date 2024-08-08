class_name ModuleMapTracker extends Node2D

@export var map_data : MapData
var cur_cell : MapCell

func _process(_dt:float) -> void:
	update_current_cell()

func update_current_cell() -> void:
	cur_cell = map_data.grid.get_cell_at( map_data.grid.real_pos_to_grid_pos(global_position) )

func get_area() -> MapArea:
	return cur_cell.area
