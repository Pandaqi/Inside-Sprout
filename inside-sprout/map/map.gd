class_name Map extends Node2D

@export var map_data : MapData
@export var area_drawer_scene : PackedScene
@export var area_group_drawer_scene : PackedScene
@export var heart_scene : PackedScene
@export var element_data : ElementData
@export var bg_scene : PackedScene
@onready var map_layers : MapLayers = $MapLayers
@onready var border_bodies := $BorderBodies

@export var machine_scene : PackedScene
@export var resource_hedge : MachineType

func activate() -> void:
	GSignal.place_hedge.connect(on_hedge_requested)
	
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
	areas.subdivide(grid)
	map_data.areas = areas
	
	# determine heart placement
	var hearts = MapHearts.new()
	map_data.hearts = hearts
	var num_hearts := Global.config.hearts_num
	var min_cells_between := Global.config.hearts_min_cells_between
	hearts.place(grid, num_hearts, min_cells_between)
	
	# create interiors around it
	for heart in hearts.cells:
		areas.create_interior_around(heart, grid)
	
	# color the terrain
	areas.recolor(grid, element_data)
	
	# visualize
	# the areas in the background
	for area in areas.areas:
		var node : MapAreaDrawer = area_drawer_scene.instantiate()
		map_layers.add_to_layer("floor", node)
		node.update(area)
	
	# mark the edges of interior spaces
	for group in areas.area_groups:
		var node : MapAreaGroupDrawer = area_group_drawer_scene.instantiate()
		map_layers.add_to_layer("entities", node)
		node.update(group)
	
	# create hedges on the edges (sick rhyme)
	for group in areas.area_groups:
		for i in range(group.hedges_taken.size()-1,-1,-1):
			place_hedge(group, group.hedges_taken[i])
	
	# the heart cells where they need to be
	for heart_cell in hearts.cells:
		place_heart(heart_cell)
	
	# create physical map bounds
	create_map_bounds()

func create_map_bounds() -> void:
	var border_thickness := 24.0
	var grid_bounds := map_data.grid.get_bounds()
	var border_size := grid_bounds.size
	border_size.x = max(border_size.x, border_size.y)
	border_size.y = border_thickness
	
	var shp := RectangleShape2D.new()
	shp.size = border_size
	
	var positions = [
		Vector2(0.5*grid_bounds.size.x, 0),
		Vector2(grid_bounds.size.x, 0.5*grid_bounds.size.y),
		Vector2(0.5 * grid_bounds.size.x, grid_bounds.size.y),
		Vector2(0, 0.5*grid_bounds.size.y)
	]
	
	for i in range(4):
		var body := StaticBody2D.new()
		body.set_collision_layer_value(3, true)
		var col_shape := CollisionShape2D.new()
		col_shape.shape = shp
		body.add_child(col_shape)
		body.set_position(positions[i])
		body.set_rotation(i * 0.5 * PI)
		border_bodies.add_child(body)

func place_heart(cell:MapCell) -> void:
	var node : Heart = heart_scene.instantiate()
	node.set_position( map_data.grid.grid_pos_float_to_real_pos( cell.get_center() ) )
	map_layers.add_to_layer("entities", node)
	cell.heart_node = node
	
	node.state.died.connect(map_data.hearts.on_heart_died)
	node.activate()

func place_hedge(group:MapAreaGroup, known_hedge:Line = null) -> void:
	if not known_hedge and (not group.can_place_hedge()): return
	
	var hedge := known_hedge 
	if not hedge:
		hedge = group.hedges_available.back()
	
	var node = machine_scene.instantiate()
	node.set_position( map_data.grid.grid_pos_float_to_real_pos( hedge.get_center() ))
	map_layers.add_to_layer("entities", node)

	node.set_direction(hedge.angle())
	node.set_type(resource_hedge)
	
	node.state.died.connect(func(_n): group.add_hedge(hedge))
	node.activate()
	group.remove_hedge(hedge)

func on_hedge_requested(group:MapAreaGroup) -> void:
	place_hedge(group)
