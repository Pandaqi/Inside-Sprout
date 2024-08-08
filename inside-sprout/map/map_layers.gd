class_name MapLayers extends Node2D

@export var layer_names : Array[String] = []
var layers : Dictionary = {}

func _ready():
	GSignal.place_on_map.connect(on_placement_requested)
	
	for layer in layer_names:
		var node := Node2D.new()
		node.y_sort_enabled = true
		add_child(node)
		layers[layer] = node

func on_placement_requested(layer:String, obj:Node2D) -> void:
	add_to_layer(layer, obj)

func add_to_layer(layer:String, obj:Node2D) -> void:
	layers[layer].add_child(obj)
		
