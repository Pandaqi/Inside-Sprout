extends Resource
class_name ElementData

@export var all_types : Array[ElementType] = []
var available_types : Array[ElementType] = []
var spawnable_types : Array[ElementType] = [] # the types that can be spawned randomly and picked up (and thus not an area or result of conversion)
var area_types : Array[ElementType] = [] # the types that areas can be (and thus elements can be after conversion)

var elements : Array[Element] = []

signal element_added(e:Element)
signal element_removed(e:Element)

func reset() -> void:
	available_types = []
	spawnable_types = []
	area_types = []

func count() -> int:
	return elements.size()

func add_element(e:Element) -> void:
	elements.append(e)
	element_added.emit(e)

func remove_element(e:Element) -> void:
	elements.erase(e)
	element_removed.emit(e)
