class_name WavesDisplayer extends Node2D

@export var enemy_data : EnemyData
@onready var container := $Container
@onready var labels := [$Container/Label1, $Container/Label2]
@onready var root_petal := $Container/Petals/Petal1
@onready var petal_container := $Container/Petals
@onready var unlocks := $Container/Unlocks
@onready var unlock_scene := $Container/Unlocks/Unlock
@onready var flower_center := $Container/FlowerCenter
@onready var audio_player := $AudioStreamPlayer
@onready var ui : UI = get_parent()

@onready var choices := $Container/Choices

const FRAME_START := 10
const FRAME_END := 12

var petal_outset := 112.0

func activate() -> void:
	enemy_data.spawner.wave_started.connect(on_wave_started)
	enemy_data.spawner.wave_ended.connect(on_wave_ended)
	set_visible(false)
	
	var num := Global.config.waves_max
	for i in range(num-1):
		var p = root_petal.duplicate()
		petal_container.append_child(p)

func on_wave_started() -> void:
	set_position(0.5*get_viewport_rect().size)
	
	ui.set_bg(true)
	audio_player.play()
	get_tree().paused = true
	
	for label in labels:
		label.set_text(str(enemy_data.spawner.wave_index + 1))
	
	var new_unlock := enemy_data.spawner.last_unlocked_type
	unlocks.set_visible(false)
	if new_unlock:
		unlocks.set_visible(true)
		unlock_scene.set_data(new_unlock)
	
	choices.set_visible(false)
	if not new_unlock:
		choices.set_visible(true)
		choices.update()
	
	container.set_scale(Vector2.ZERO)
	flower_center.set_frame(FRAME_START)
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(container, "scale", 1.1*Vector2.ONE, 0.2)
	tw.tween_property(container, "scale", Vector2.ONE, 0.1)
	
	var counter := 0
	var num_petals := Global.config.waves_max
	var final_tween := tw
	for petal in petal_container.get_children():
		var ang := counter / float(num_petals) * 2 * PI
		counter += 1
		
		petal.set_scale(Vector2.ZERO)
		petal.set_position(Vector2.ZERO)
		petal.set_rotation(ang)
		
		var circle_pos := Vector2.from_angle(ang) * petal_outset
		
		var tw_pet = get_tree().create_tween()
		tw_pet.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tw_pet.tween_interval(counter * randf_range(0.15, 0.35))
		tw_pet.tween_property(petal, "scale", Vector2.ONE, 0.3)
		tw_pet.parallel().tween_property(petal, "position", circle_pos, 0.3)
		final_tween = tw_pet
	
	await final_tween.finished
	
	var extra_node := unlocks if unlocks.is_visible() else choices
	if extra_node:
		extra_node.set_scale(Vector2.ZERO)
		extra_node.modulate.a = 0.0
		var tw_unlock := get_tree().create_tween()
		tw_unlock.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tw_unlock.tween_property(extra_node, "scale", 1.1*Vector2.ONE, 0.2)
		tw_unlock.parallel().tween_property(extra_node, "modulate:a", 1.0, 0.3)
		tw_unlock.tween_property(extra_node, "scale", Vector2.ONE, 0.1)
		await tw_unlock.finished
	
	if choices.is_visible():
		choices.make_clickable()
		await choices.chosen
	
	var tw_remove := get_tree().create_tween()
	tw_remove.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw_remove.tween_interval(Global.config.waves_delay_before_start)
	tw_remove.tween_property(container, "scale", 1.1*Vector2.ONE, 0.1)
	tw_remove.tween_property(container, "scale", Vector2.ZERO, 0.2)
	ui.set_bg(false)
	
	await tw_remove.finished
	
	get_tree().paused = false

func on_wave_ended() -> void:
	get_tree().paused = true
	audio_player.play()
	flower_center.set_frame(FRAME_END)
	
	unlocks.set_visible(false)
	
	container.set_scale(Vector2.ZERO)
	var tw := get_tree().create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(container, "scale", 1.1*Vector2.ONE, 0.2)
	tw.tween_property(container, "scale", Vector2.ONE, 0.1)
	tw.tween_interval(1.0)
	tw.tween_property(container, "scale", 1.1*Vector2.ONE, 0.1)
	tw.tween_property(container, "scale", Vector2.ZERO, 0.2)
	
	await tw.finished
	
	get_tree().paused = false
	enemy_data.spawner.start()
