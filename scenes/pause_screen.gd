extends Control

signal closed

var settings_menu_scene: PackedScene = load("res://scenes/settings_menu.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameStatus.is_paused = true


func _on_continue_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameStatus.is_paused = false
	closed.emit()
	self.queue_free()
	


func _on_settings_button_pressed() -> void:
	var new_settings: Control = settings_menu_scene.instantiate()
	self.add_child(new_settings)



func _on_menu_button_pressed() -> void:
	GlobalLoader.change_scene("res://scenes/title_screen.tscn")
