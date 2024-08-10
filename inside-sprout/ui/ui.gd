class_name UI extends CanvasLayer
 
@onready var waves_displayer := $WavesDisplayer
@onready var tutorial := $Tutorial
@onready var game_over := $GameOver
@onready var color_rect := $ColorRect
@onready var anim_player := $AnimationPlayer

func activate() -> void:
	waves_displayer.activate()
	tutorial.activate()
	game_over.activate()

func set_bg(val:bool) -> void:
	if val: anim_player.play("fade_bg")
	else: anim_player.play_backwards("fade_bg")
