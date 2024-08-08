extends MovementType
class_name MovementEnemyDefault

func update(mover:ModuleMover) -> Vector2:
	var target_element := mover.sensor.get_target_element()
	var cur_pos := mover.global_position
	var target_pos := Vector2.ZERO
	if target_element:
		target_pos = target_element.global_position
	else:
		var closest_heart := mover.map_data.get_closest_heart_to(mover.global_position)
		target_pos = closest_heart.global_position
	
	var vec := (target_pos - cur_pos).normalized()
	return vec * speed * mover.get_speed_factor()
