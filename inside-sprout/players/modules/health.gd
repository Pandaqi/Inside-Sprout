class_name ModuleHealth extends Node2D

@export var show_progress_bar := true

@onready var entity = get_parent()
@onready var anim_player : AnimationPlayer = $BarContainer/AnimationPlayer
@onready var prog_bar : TextureProgressBar = $BarContainer/Bar
@onready var prog_bar_cont : Node2D = $BarContainer

var base_health := 100.0
var health := 0.0
var last_attacker : Node2D

signal depleted()

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
	health = clamp(health + h, 0.0, base_health)
	
	prog_bar_cont.set_visible(show_progress_bar)
	if show_progress_bar:
		prog_bar.set_value(get_health_ratio() * 100)
		anim_player.stop()
		anim_player.play("health_change")
	
	if health <= 0:
		depleted.emit()

func register_attacker(body:Node2D) -> void:
	last_attacker = body
