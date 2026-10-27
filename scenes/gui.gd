extends CanvasLayer

var pause_screen_scene: PackedScene = preload("res://scenes/pause_screen.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		self.add_child(pause_screen_scene.instantiate())


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
