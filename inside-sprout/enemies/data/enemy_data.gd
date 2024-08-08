extends Resource
class_name EnemyData

@export var all_enemies : Array[EnemyType] = []
var available_enemies : Array[EnemyType] = []

var spawner : SpawnerWaves
var enemies : Array[Enemy] = []

signal enemy_added(e:Enemy)
signal enemy_removed(e:Enemy)

func reset() -> void:
	spawner = null
	available_enemies = []

func get_random_available() -> EnemyType:
	return available_enemies.pick_random()

func count() -> int:
	return enemies.size()

func add_enemy(e:Enemy) -> void:
	enemies.append(e)
	enemy_added.emit(e)

func remove_enemy(e:Enemy) -> void:
	enemies.erase(e)
	enemy_removed.emit(e)

func unlock(tp:EnemyType) -> void:
	available_enemies.append(tp)
