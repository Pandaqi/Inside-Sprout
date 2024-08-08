class_name Map extends Node2D

@export var map_data : MapData
@export var area_drawer_scene : PackedScene
@export var heart_scene : PackedScene
@export var element_data : ElementData
@export var bg_scene : PackedScene
@onready var map_layers : MapLayers = $MapLayers

func activate() -> void:
	regenerate()
	create_background()

func create_background() -> void:
	var levels := Global.config.map_background_layers
	var sc := Global.config.map_background_scale_per_layer
	var map_bounds := map_data.get_bounds()
	
	for i in range(levels-1,-1,-1):
		var node = bg_scene.instantiate()
		node.set_position(map_bounds.get_center())
		var new_scale := map_bounds.size / 128.0 * (1.0 + i*sc)
		node.set_data(new_scale, i)
		map_layers.add_to_layer("bg", node)

func regenerate() -> void:
	# create the core grid
	var size = Global.config.map_size
	var grid = MapGrid.new()
	grid.create(size)
	map_data.grid = grid
	
	# subdivide it into areas
	var areas = MapAreas.new()
	areas.subdivide(grid, element_data)
	map_data.areas = areas
	
	# determine heart placement
	var hearts = MapHearts.new()
	map_data.hearts = hearts
	var num_hearts := Global.config.hearts_num
	var min_cells_between := Global.config.hearts_min_cells_between
	hearts.place(grid, num_hearts, min_cells_between)
	
	# visualize
	for area in areas.areas:
		var node : MapAreaDrawer = area_drawer_scene.instantiate()
		map_layers.add_to_layer("floor", node)
		node.update(area)
	
	for heart_cell in hearts.cells:
		var node : Heart = heart_scene.instantiate()
		node.set_position( grid.grid_pos_to_real_pos( heart_cell.get_center() ) )
		map_layers.add_to_layer("entities", node)
		heart_cell.heart_node = node
		
		node.died.connect(hearts.on_heart_died)

	
	
	
