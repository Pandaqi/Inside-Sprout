class_name ModuleProperties extends Node2D

@export var element_data : ElementData
@export var sprite_scene : PackedScene
var sprites : Array[ElementSprite] = []

func set_type(tp:EnemyType) -> void:
	var distractions := tp.distractions
	if tp.distractions_all: distractions = element_data.area_types
	
	var weaknesses := tp.weaknesses
	if tp.weaknesses_all: weaknesses = element_data.area_types
	
	visualize(distractions, weaknesses)

func visualize(dis:Array[ElementType], weak:Array[ElementType]) -> void:
	for sprite in sprites:
		sprite.queue_free()
	
	sprites = []
	
	for i in range(dis.size()):
		var new_sprite : ElementSprite = sprite_scene.instantiate()
		add_child(new_sprite)
		sprites.append(new_sprite)
	
	var offset_per_sprite := Vector2.RIGHT * Global.config.sprite_size
	var global_offset := -0.5 * (dis.size() - 1) * offset_per_sprite
	for i in range(sprites.size()):
		var sprite = sprites[i]
		var is_weak := weak.has(dis[i])
		sprite.set_data(dis[i].frame, is_weak)
		sprite.set_position(global_offset + i * offset_per_sprite)
		
