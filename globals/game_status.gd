extends Node

var is_paused: bool = false

var is_middle_mouse_pressed: bool = false

var player: CharacterBody3D

func get_player_node() -> void:
	player = get_tree().get_first_node_in_group("player")
