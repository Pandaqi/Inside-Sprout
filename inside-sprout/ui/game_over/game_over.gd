class_name GameOver extends Node2D

const WIN_TEXT = "Congratulations! You defeated the final wave! You're a true master gardener."
const LOSE_TEXT = "Unfortunately, your flower defence was just not enough ..."

@onready var desc := $Container/Desc
@onready var restart_btn := $Container/Buttons/Restart
@onready var anim_player := $AnimationPlayer
@onready var audio_player := $AudioStreamPlayer

var active := false

func activate():
	active = false
	set_visible(false)

func appear(we_won:bool) -> void:
	get_tree().paused = true
	audio_player.play()
	set_visible(true)
	set_position(get_viewport_rect().size)
	
	var txt := WIN_TEXT if we_won else LOSE_TEXT
	desc.set_text(txt)
	
	anim_player.play("appear")
	restart_btn.grab_focus()
	active = true

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://game_loop/menu/menu.tscn")

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _input(ev:InputEvent) -> void:
	if not active: return
	if ev.is_action_released("game_over_restart"):
		_on_restart_pressed()
	if ev.is_action_released("game_over_back"):
		_on_back_pressed()
