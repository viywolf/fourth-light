extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainTitleScreen.size = get_viewport_rect().size
	$MainTitleScreen/ButtonsContainer.custom_minimum_size.y = get_viewport_rect().size.y / 2


func _on_start_button_pressed() -> void:
	$GridContainer.show()
	$MainTitleScreen.hide()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_to_menu_button_pressed() -> void:
	$GridContainer.hide()
	$MainTitleScreen.show()


func _on_main_scene_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_movement_scene_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/movement_stage.tscn")
	

func _on_glide_scene_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/glide_stage.tscn")
	

func _on_swim_scene_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stages/swim_stage.tscn")


func _on_chunk_scene_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/chunk_loading_test.tscn")
