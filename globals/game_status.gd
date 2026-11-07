extends Node

var is_paused: bool = false

var is_middle_mouse_pressed: bool = false

## The player node, which should be automatically set 
## in the player controller _ready()
var player: CharacterBody3D

func get_player_node() -> void:
	player = get_tree().get_first_node_in_group("player")
