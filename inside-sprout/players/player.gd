class_name Player extends CharacterBody2D

var player_num := -1

@onready var input := $Input
@onready var mover := $Mover
@onready var element_converter := $ElementConverter
@onready var element_dropper := $ElementDropper
@onready var map_tracker := $MapTracker
@onready var state := $State

func activate(pnum:int) -> void:
	player_num = pnum
	state.activate()
	input.activate(pnum)
	element_converter.activate()
	element_dropper.activate()
	mover.activate()
	map_tracker.activate()
