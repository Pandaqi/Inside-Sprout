class_name ModuleElementDropper extends Node2D

@export var element_converter : ModuleElementConverter
@export var map_tracker : ModuleMapTracker
@onready var audio_player := $AudioStreamPlayer2D

func activate() -> void:
	element_converter.available_for_drop.connect(drop)

func drop(et:ElementType) -> void:
	GSignal.drop_element.emit(et, global_position)
	
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
	
	var r := map_tracker.get_rules()
	if r.drop_regrow_hedge and map_tracker.get_area_group().is_interior():
		GSignal.place_hedge.emit(map_tracker.get_area_group())
	
	var heal_factor := r.drop_heal_factor * Global.config.hearts_heal_def
	if not is_zero_approx(heal_factor):
		map_tracker.map_data.hearts.heal(heal_factor)
