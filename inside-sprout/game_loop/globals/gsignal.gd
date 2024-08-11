extends Node

signal game_over(we_won:bool)
signal place_on_map(layer:String, obj:Node2D)
signal drop_element(et:ElementType, pos:Vector2)
signal place_hedge(group:MapAreaGroup)

func _ready() -> void:
	var a = AudioStreamPlayer.new()
	a.stream = preload("res://game_loop/globals/theme_song_inside_sprout.ogg")
	a.volume_db = -16
	a.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(a)
	a.play()
