extends Control

signal closed

var settings_menu_scene: PackedScene = load("res://scenes/ui_scenes/settings_menu.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameStatus.is_paused = true
	PhysicsServer3D.set_active(false)
	for node in get_tree().get_nodes_in_group("ui"):
		node.hide()


func _on_continue_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameStatus.is_paused = false
	PhysicsServer3D.set_active(true)
	closed.emit()
	for node in get_tree().get_nodes_in_group("ui"):
		node.show()
	self.queue_free()
	


func _on_settings_button_pressed() -> void:
	var new_settings: Control = settings_menu_scene.instantiate()
	self.add_child(new_settings)



func _on_menu_button_pressed() -> void:
	GlobalLoader.change_scene("res://scenes/ui_scenes/title_screen.tscn")
