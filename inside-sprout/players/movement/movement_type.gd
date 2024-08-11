extends Resource
class_name MovementType

@export var speed := 1.0

func update(_dt:float, mover:ModuleMover) -> Vector2:
	if not mover.input: return Vector2.ZERO
	var vec := mover.input.get_vector()
	return speed * mover.get_speed_factor() * vec

func get_heart_focused_movement(dt:float, mover:ModuleMover) -> Vector2:
	var target_element := mover.sensor.get_target_element()
	var cur_pos := mover.global_position
	var target_pos := cur_pos
	
	var closest_heart := mover.map_data.get_closest_heart_to(mover.global_position)
	if closest_heart:
		target_pos = closest_heart.global_position
	
	if target_element:
		target_pos = target_element.global_position
		
	var vec := (target_pos - cur_pos)
	var final_speed := speed * mover.get_speed_factor()
	var dist := vec.length() 
	var vec_norm := vec.normalized()
	var estimated_move_dist := 3 * final_speed * dt
	if estimated_move_dist >= dist: return Vector2.ZERO
	return vec_norm * final_speed
