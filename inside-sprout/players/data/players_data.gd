extends Resource
class_name PlayersData

var players : Array[Player] = []

signal player_added(p:Player)
signal player_removed(p:Player)

signal player_switched_in_out(p:Player, val:MapAreas.InOut)

func reset() -> void:
	players = []

func count() -> int:
	return players.size()

func add_player(p:Player) -> void:
	players.append(p)
	p.map_tracker.switched_in_out.connect(func(val): player_switched_in_out.emit(p, val))
	player_added.emit(p)

func remove_player(p:Player) -> void:
	players.erase(p)
	player_removed.emit(p)
