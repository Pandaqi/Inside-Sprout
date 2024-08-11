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
	clean_up_enemies()
	enemy_removed.emit(e)

# @NOTE: sometimes, it doesn't properly erase them, perhaps because the remove_enemy call happens too late => this just cleans it up so it doesn't remember "freed enemies" as if they still exist
func clean_up_enemies() -> void:
	for i in range(enemies.size() - 1, -1, -1):
		var en := enemies[i]
		if en and is_instance_valid(en): continue
		enemies.remove_at(i)

func unlock(tp:EnemyType) -> void:
	available_enemies.append(tp)
