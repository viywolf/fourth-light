extends Node

var loading_screen: PackedScene = load("res://scenes/ui_scenes/loading_screen.tscn")


func change_scene(scene_path: String) -> void:
	var new_loading_screen = loading_screen.instantiate()
	new_loading_screen.scene_to_load_path = scene_path
	get_tree().root.add_child(new_loading_screen)
