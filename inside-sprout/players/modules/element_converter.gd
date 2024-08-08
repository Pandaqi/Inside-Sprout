class_name ModuleElementConverter extends Node2D

@export var map_tracker : ModuleMapTracker
@export var element_grabber : ModuleElementGrabber
var processes : Array[ElementConversionProcess] = []

signal available_for_drop(et:ElementType)

func activate() -> void:
	element_grabber.available_for_processing.connect(process_element)

func process_element(et:ElementType):
	print("Should process element")
	var dur := Global.config.elements_conversion_duration_bounds.rand_float()
	var proc := ElementConversionProcess.new(dur, et)
	add_child(proc)
	proc.create_timer()
	proc.finished.connect(on_process_complete)
	visualize()

func on_process_complete(ecp:ElementConversionProcess):
	print("Process complete")
	var type := map_tracker.get_area().type
	available_for_drop.emit(type)
	processes.erase(ecp)
	ecp.queue_free()
	visualize()

func visualize() -> void:
	pass
	# @TODO: display some animation while busy
	# @TODO: change how active processes are arranged/shown
