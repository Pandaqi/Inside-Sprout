class_name MapAreaGroupDrawer extends Node2D

@export var map_data : MapData
var area_group : MapAreaGroup

var polygon : PackedVector2Array

@onready var debug_label_cont := $DebugLabel
@onready var debug_label := $DebugLabel/Label

func _ready() -> void:
	debug_label_cont.set_visible(OS.is_debug_build() and Global.config.show_area_label)

func update(g:MapAreaGroup) -> void:
	area_group = g
	
	polygon = []
	for point in area_group.outline:
		polygon.append(map_data.grid.grid_pos_to_real_pos(point))
	
	queue_redraw()

func _draw() -> void:
	draw_polyline(polygon, Color(0.5,0.25,0.12), 4)
