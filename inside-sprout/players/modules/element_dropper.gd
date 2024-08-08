class_name ModuleElementDropper extends Node2D

@export var element_converter : ModuleElementConverter

func activate() -> void:
	element_converter.available_for_drop.connect(drop)

func drop(et:ElementType) -> void:
	print("Should drop element")
	GSignal.drop_element.emit(et, global_position)
