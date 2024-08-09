class_name MapCell

var pos : Vector2i
var edges : Array[Line]
var nbs : Array[MapCell]
var area : MapArea = null
var heart_node : Heart
var objects = []

signal object_entered(o)
signal object_exited(o)

func _init(p:Vector2i):
	set_position(p)

func add_object(o) -> void:
	if not ("map_tracker" in o): return
	objects.append(o)
	object_entered.emit(o)

func remove_object(o) -> void:
	if not ("map_tracker" in o): return
	objects.erase(o)
	object_exited.emit(o)

func set_position(p:Vector2i) -> void:
	pos = p
	
	var pos_raw := Vector2(pos)
	# must wind clockwise!
	edges = [
		Line.new(pos_raw, pos_raw+Vector2.RIGHT),
		Line.new(pos_raw+Vector2.RIGHT, pos_raw+Vector2.ONE),
		Line.new(pos_raw+Vector2.ONE, pos_raw+Vector2.DOWN),
		Line.new(pos_raw+Vector2.DOWN, pos_raw)
	]

func has_area() -> bool:
	return area != null

func get_center() -> Vector2:
	return Vector2(pos.x+0.5, pos.y+0.5)

func get_random_point_within() -> Vector2:
	return Vector2(pos.x + randf(), pos.y + randf())
