class_name SpawnEvent 

var type : EnemyType
var time_diff : float # if previous spawn + time_diff surpassed, this one should spawn

func _init(t:EnemyType, tm:float):
	type = t
	time_diff = tm
