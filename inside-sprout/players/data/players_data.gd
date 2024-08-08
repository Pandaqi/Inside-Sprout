extends Resource
class_name PlayersData

var players : Array[Player] = []

signal player_added(p:Player)
signal player_removed(p:Player)

func reset() -> void:
	players = []

func count() -> int:
	return players.size()

func add_player(p:Player) -> void:
	players.append(p)
	player_added.emit(p)

func remove_player(p:Player) -> void:
	players.erase(p)
	player_removed.emit(p)
