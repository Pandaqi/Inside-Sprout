extends Node

signal game_over(we_won:bool)
signal place_on_map(layer:String, obj:Node2D)
signal drop_element(et:ElementType, pos:Vector2)
signal place_hedge(group:MapAreaGroup)
