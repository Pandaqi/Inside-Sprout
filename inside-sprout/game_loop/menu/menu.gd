extends Control

@onready var play_btn := $CenterContainer/VBoxContainer/Play
@onready var quit_btn := $CenterContainer/VBoxContainer/Quit

func _ready() -> void:
	play_btn.grab_focus()

func _input(ev:InputEvent) -> void:
	if ev.is_action_released("game_over_restart"):
		_on_play_pressed()
	if ev.is_action_released("game_over_back"):
		_on_quit_pressed()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://game_loop/main/main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
