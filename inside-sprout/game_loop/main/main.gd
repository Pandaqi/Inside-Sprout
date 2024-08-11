extends Node2D

@onready var map := $Map
@onready var enemies := $Enemies
@onready var players := $Players
@onready var elements := $Elements
@onready var progression := $Progression
@onready var ui := $UI

func _ready() -> void:
	players.preactivate()
	elements.preactivate()
	progression.preactivate()
	
	map.activate()
	players.activate()
	enemies.activate()
	elements.activate()
	progression.activate()
	ui.activate()
	
	if not (OS.is_debug_build() and Global.config.skip_pregame):
		ui.tutorial.load_next()
		await ui.tutorial.done
	
	enemies.load_next_wave()
