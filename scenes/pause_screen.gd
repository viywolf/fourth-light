extends Control


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GameStatus.is_paused = true
	get_tree().paused = true


func _on_continue_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameStatus.is_paused = false
	get_tree().paused = false
	self.queue_free()
	


func _on_settings_button_pressed() -> void:
	# Open settings menu
	pass # Replace with function body.



func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
