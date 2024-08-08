extends Sprite2D

func set_data(new_scale:Vector2, i:int):
	material = material.duplicate(false)
	var c := Global.config.map_background_color
	c = c.darkened(i * 0.1)
	material.set_shader_parameter("color", c)
	material.set_shader_parameter("speed", randf_range(0.05, 0.1))
	material.set_shader_parameter("seed", randf() - 0.5)
	
	set_scale(new_scale)
