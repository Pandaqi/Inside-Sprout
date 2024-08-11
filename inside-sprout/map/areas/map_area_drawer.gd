class_name MapAreaDrawer extends Node2D

enum AreaDrawMode
{
	OUTLINE,
	CELLS
}

@export var map_data : MapData
var area : MapArea

var polygon : PackedVector2Array
var polygon_uvs : PackedVector2Array

@onready var debug_label_cont := $DebugLabel
@onready var debug_label := $DebugLabel/Label
@export var draw_mode := AreaDrawMode.OUTLINE

func _ready() -> void:
	material = material.duplicate(false)
	material.set_shader_parameter("jaggy_start_threshold", randf_range(0.03, 0.04))
	material.set_shader_parameter("speed", randf_range(0.4, 0.66))
	material.set_shader_parameter("noise_hard_cutoff_threshold", randf_range(0.2, 0.3))
	
	debug_label_cont.set_visible(OS.is_debug_build() and Global.config.show_area_label)

func update(a:MapArea) -> void:
	area = a
	area.type_changed.connect(on_type_changed)
	on_type_changed(area.type)
	
	# @NOTE: this is used to make bigger areas lower their scale, so that the shader effect looks roughly same size everywhere
	var base_scale := 8.0 # for which number of edges the parameters above have been calibrated
	var compensate_scale := 1.0 / area.outline.size() * base_scale
	material.set_shader_parameter("noise_scale", compensate_scale)
	
	create_uvs()
	queue_redraw()

func on_type_changed(_new_type:ElementType) -> void:
	material.set_shader_parameter("color", area.type.color)

func create_uvs() -> void:
	polygon = []
	
	var bb_min := Vector2(INF, INF)
	var bb_max := Vector2(-INF, -INF)
	for point in area.outline:
		bb_min.x = min(bb_min.x, point.x)
		bb_min.y = min(bb_min.y, point.y)
		bb_max.x = max(bb_max.x, point.x)
		bb_max.y = max(bb_max.y, point.y)
		
		polygon.append(map_data.grid.grid_pos_to_real_pos(point))

	# @NOTE: uvs pretend they're in a circle, so the shader knows what is the "edge" and can manipulate accordingly
	polygon_uvs = []
	var size := bb_max - bb_min
	var center := 0.5 * (bb_max + bb_min)
	var num_points := area.outline.size()
	for i in range(num_points):
		# var uv_precise := (area.outline[i] - bb_min) / size
		var uv_circular := Vector2(0.5, 0.5) + 0.5*Vector2.from_angle(i / float(num_points - 1) * 2 * PI)
		polygon_uvs.append(uv_circular)
	
	debug_label_cont.set_position(center * Global.config.cell_size)
	debug_label.set_text("#" + str(area.id) + " / #" + str(area.group))

func _draw() -> void:
	if draw_mode == AreaDrawMode.CELLS:
		var cs := Global.config.cell_size
		var rand_col := Color(randf(), randf(), randf())
		for cell in area.cells:
			var real_pos := map_data.grid.grid_pos_to_real_pos(cell.pos)
			draw_rect(Rect2(real_pos.x, real_pos.y, cs, cs), rand_col)
		return
	
	if draw_mode == AreaDrawMode.OUTLINE:
		draw_polygon(polygon, [Color(1,1,1)], polygon_uvs)
		return
