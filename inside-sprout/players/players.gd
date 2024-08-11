class_name Players extends Node2D

@export var player_scene : PackedScene
@export var players_data : PlayersData
@export var map_data : MapData

func preactivate() -> void:
	players_data.reset()
	# GInput.create_debugging_players()
	if GInput.get_player_count() <= 0:
		GInput.add_new_player(GInput.InputDevice.KEYBOARD)

func activate() -> void:
	place_players()

func place_players() -> void:
	for i in range(GInput.get_player_count()):
		place_player(i)

func place_player(num:int) -> void:
	var p : Player = player_scene.instantiate()
	p.set_position( map_data.grid.get_random_position() )
	GSignal.place_on_map.emit("entities", p)
	players_data.add_player(p)
	p.state.died.connect(func(_p): players_data.remove_player(p))
	p.activate(num)
