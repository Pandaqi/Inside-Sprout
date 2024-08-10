extends Node2D

@export var prog_data : ProgressionData
var choices : Array[Ruleset]
var active := false

@onready var choice_left := $ChoiceLeft
@onready var choice_right := $ChoiceRight

signal chosen()

func _ready() -> void:
	choice_left.pressed.connect(on_left_pressed)
	choice_right.pressed.connect(on_right_pressed)

func update() -> void:
	var all_options := prog_data.all_rules.duplicate(false)
	all_options.shuffle()
	choices = [all_options.pop_back(), all_options.pop_back()]
	
	choice_left.set_text(choices.front().desc)
	choice_left.set_text(choices.back().desc)

func on_left_pressed() -> void:
	if not active: return
	on_chosen(choices.front())

func on_right_pressed() -> void:
	if not active: return
	on_chosen(choices.back())

func on_chosen(rs:Ruleset) -> void:
	active = false
	prog_data.update_ruleset(rs)
	chosen.emit()

func make_clickable() -> void:
	choice_left.grab_focus()
	active = true
