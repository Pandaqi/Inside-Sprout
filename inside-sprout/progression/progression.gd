class_name Progression extends Node2D

@export var game_over : GameOver

func activate() -> void:
	GSignal.game_over.connect(on_game_over)

func on_game_over(we_won:bool) -> void:
	print("GAME OVER!")
	print("We won? ", we_won)
	game_over.appear(we_won)
