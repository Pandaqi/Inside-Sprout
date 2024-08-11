class_name SpawnEvent 

var type : EnemyType
var time_diff : float # if previous spawn + time_diff surpassed, this one should spawn

func _init(t:EnemyType, tm:float = 0.0):
	type = t
	time_diff = tm
