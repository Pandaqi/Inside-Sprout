class_name ModuleElementConverter extends Node2D

@export var map_tracker : ModuleMapTracker
@export var element_grabber : ModuleElementGrabber
@export var conversion_sprite_scene : PackedScene
var processes : Array[ElementConversionProcess] = []
var sprites : Array[ElementConversionSprite] = []

signal available_for_drop(et:ElementType)

func activate() -> void:
	element_grabber.available_for_processing.connect(process_element)
	map_tracker.switched_in_out.connect(on_switched_in_out)

func process_element(et:ElementType):
	var dur := Global.config.elements_conversion_duration
	var prev_dur := 0
	if processes.size() > 0:
		prev_dur = processes.back().get_time_remaining()
	
	var processes_too_close : bool = abs(dur - prev_dur) < Global.config.elements_conversion_min_diff
	if processes_too_close:
		dur = Global.config.elements_conversion_min_diff
	
	var proc := ElementConversionProcess.new(dur, et)
	proc.finished.connect(on_process_complete)
	processes.append(proc)
	visualize()

func on_process_complete(ecp:ElementConversionProcess):
	var type := map_tracker.get_area().type
	available_for_drop.emit(type)
	processes.erase(ecp)
	visualize()

func _process(dt:float) -> void:
	var time_scale := map_tracker.get_rules().conversion_timer_factor
	for sprite in sprites:
		sprite.update(dt * time_scale)

func on_switched_in_out(_val:MapAreas.InOut) -> void:
	var r := map_tracker.get_rules()
	if r.conversion_insta_finish:
		for proc in processes:
			proc.finish()

func visualize() -> void:
	var num_proc := processes.size()
	while sprites.size() < num_proc:
		var node = conversion_sprite_scene.instantiate()
		add_child(node)
		sprites.append(node)
	
	var offset_per_sprite := Vector2.RIGHT * Global.config.sprite_size
	var global_offset := -0.5 * (num_proc - 1) * offset_per_sprite
	for i in range(sprites.size()):
		var should_show := i < num_proc
		var sprite := sprites[i]
		if should_show: sprite.set_conv_proc(processes[i])
		else: sprite.set_conv_proc(null)
		sprite.set_visible(should_show)
		sprite.set_position(global_offset + i*offset_per_sprite)
