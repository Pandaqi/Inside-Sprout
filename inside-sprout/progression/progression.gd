class_name Progression extends Node

func activate() -> void:
	GSignal.game_over.connect(on_game_over)

func on_game_over(we_won:bool) -> void:
	print("GAME OVER!")
	print("We won? ", we_won)
	
	# @TODO: display game over screen, animate/delay, possibility of restart
