class_name Tutorial extends Node2D

@onready var sprite := $Sprite2D
@onready var anim_player := $AnimationPlayer
@onready var ui : UI = get_parent()

var frame := -1
var max_frames := 2
var active := false

signal done()

func activate() -> void:
	set_visible(false)

func load_next() -> void:
	set_visible(true)
	set_position(0.5*get_viewport_rect().size)
	
	get_tree().paused = true
	ui.set_bg(true)
	
	frame += 1
	if frame >= max_frames:
		deactivate()
		return
	
	sprite.set_frame(frame)
	anim_player.play("tut_appear")
	await anim_player.animation_finished
	active = true

func deactivate() -> void:
	ui.set_bg(false)
	anim_player.play_backwards("tut_appear")
	await anim_player.animation_finished
	active = false
	done.emit()

func _input(ev:InputEvent) -> void:
	if not active: return
	if ev.is_action_released("game_over_restart"):
		load_next()
