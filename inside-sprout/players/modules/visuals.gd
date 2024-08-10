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
	if not movement_tween or movement_tween.is_running(): return
	
	var tween_angle := 0.1 * PI
	var end_pos := tween_dir * Vector2.from_angle(tween_angle - 0.5 * PI) * 32.0
	var end_rot := tween_dir * tween_angle
	
	self.set_scale(Vector2.ONE)
	self.set_rotation(0)
	self.set_position(Vector2.ZERO)
	
	var tw := get_tree().create_tween()
	tw.tween_property(self, "scale", Vector2(1.1, 0.9), 0.05)
	tw.tween_property(self, "scale", Vector2(0.9, 1.1), 0.1)
	tw.parallel().tween_property(self, "position", end_pos, 0.1)
	tw.parallel().tween_property(self, "rotation", end_rot, 0.1)
	tw.tween_property(self, "scale", Vector2(1.1, 0.9), 0.1)
	tw.parallel().tween_property(self, "position", Vector2.ZERO, 0.1)
	tw.parallel().tween_property(self, "rotation", 0, 0.1)
	tw.tween_property(self, "scale", Vector2.ONE, 0.05)
	
	movement_tween = tw
