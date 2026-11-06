extends Node2D

var settings_menu_scene: PackedScene = load("res://scenes/ui_scenes/settings_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainTitleScreen.size = get_viewport_rect().size
	$MainTitleScreen/ButtonsContainer.custom_minimum_size.y = get_viewport_rect().size.y / 2


func play_click() -> void:
	$ClickEffect.play(0.2)


func _on_start_button_pressed() -> void:
	$GridContainer.show()
	$MainTitleScreen.hide()
	play_click()


func _on_settings_button_pressed() -> void:
	var new_settings: Control = settings_menu_scene.instantiate()
	self.add_child(new_settings)
	play_click()


func _on_quit_button_pressed() -> void:
	play_click()
	get_tree().quit()


func _on_back_to_menu_button_pressed() -> void:
	$GridContainer.hide()
	$MainTitleScreen.show()
	play_click()


func _on_main_scene_button_pressed() -> void:
	play_click()
	GlobalLoader.change_scene("res://scenes/main.tscn")


func _on_movement_scene_button_pressed() -> void:
	play_click()
	GlobalLoader.change_scene("res://scenes/stages/movement_stage.tscn")
	

func _on_glide_scene_button_pressed() -> void:
	play_click()
	GlobalLoader.change_scene("res://scenes/stages/glide_stage.tscn")
	

func _on_swim_scene_button_pressed() -> void:
	play_click()
	GlobalLoader.change_scene("res://scenes/stages/swim_stage.tscn")


func _on_chunk_scene_button_pressed() -> void:
	play_click()
	GlobalLoader.change_scene("res://scenes/chunk_loading_test.tscn")


func _on_interactable_scene_button_pressed() -> void:
	play_click()
	GlobalLoader.change_scene("res://scenes/features/interactions/interactability_test.tscn")
