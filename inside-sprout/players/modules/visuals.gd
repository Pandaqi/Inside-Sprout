class_name ModuleVisuals extends Node2D

@onready var sprite := $Sprite2D

var movement_tween : Tween
var tween_dir := 1

func set_data(tp:EnemyType) -> void:
	sprite.set_frame(tp.frame)

func flip(val:bool) -> void:
	sprite.flip_h = val

func animate(is_moving:bool) -> void:
	if not is_moving: return
	if movement_tween and movement_tween.is_running(): return
	
	var tween_angle := 0.1 * PI
	var pos_offset := 22.0
	var end_pos := Vector2.from_angle(tween_dir * tween_angle - 0.5 * PI) * pos_offset
	var end_rot := tween_dir * tween_angle
	
	self.set_scale(Vector2.ONE)
	self.set_rotation(0)
	self.set_position(Vector2.ZERO)
	
	var piece_dur := 0.066
	
	var tw := get_tree().create_tween()
	tw.tween_property(self, "scale", Vector2(1.1, 0.9), piece_dur)
	tw.tween_property(self, "scale", Vector2(0.9, 1.1), 2*piece_dur)
	tw.parallel().tween_property(self, "position", end_pos, 2*piece_dur)
	tw.parallel().tween_property(self, "rotation", end_rot, 2*piece_dur)
	tw.tween_property(self, "scale", Vector2(1.1, 0.9), 2*piece_dur)
	tw.parallel().tween_property(self, "position", Vector2.ZERO, 2*piece_dur)
	tw.parallel().tween_property(self, "rotation", 0, 2*piece_dur)
	tw.tween_property(self, "scale", Vector2.ONE, piece_dur)
	
	movement_tween = tw
	tween_dir *= -1
