class_name ModuleHealth extends Node2D

@export var show_progress_bar := true
@export var show_hit_flash := true

@onready var entity = get_parent()
@onready var anim_player : AnimationPlayer = $BarContainer/AnimationPlayer
@onready var prog_bar : TextureProgressBar = $BarContainer/Bar
@onready var prog_bar_cont : Node2D = $BarContainer

@onready var audio_player := $AudioStreamPlayer2D

var base_health := 100.0
var health := 0.0
var last_attacker : Node2D
var valid := false

signal depleted()

func _ready() -> void:
	valid = true

func set_base_health(h:float, fill := false) -> void:
	base_health = h
	if fill: refill()

func drain() -> void:
	change(-health)

func refill() -> void:
	health = 0
	change(base_health)

func get_health_ratio() -> float:
	return health / base_health

func change(h:float) -> void:
	if not valid: return
	
	health = clamp(health + h, 0.0, base_health)
	
	prog_bar_cont.set_visible(show_progress_bar)
	if show_progress_bar:
		prog_bar.set_value(get_health_ratio() * 100)
		anim_player.stop()
		anim_player.play("health_change")
	
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
	
	if show_hit_flash and health > 0:
		var tw := get_tree().create_tween()
		tw.tween_property(entity, "modulate", Color(3,2,2), 0.05)
		tw.parallel().tween_property(entity, "scale", 1.05*Vector2.ONE, 0.05)
		tw.tween_property(entity, "modulate", Color(1,1,1), 0.05)
		tw.parallel().tween_property(entity, "scale", Vector2.ONE, 0.05)
	
	if health <= 0:
		valid = false
		depleted.emit()

func register_attacker(body:Node2D) -> void:
	last_attacker = body
