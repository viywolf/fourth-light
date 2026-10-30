extends CanvasLayer

var pause_screen_scene: PackedScene = preload("res://scenes/pause_screen.tscn")
var is_pause_screen_active := false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and is_pause_screen_active == false:
		var new_pause_screen: Node = pause_screen_scene.instantiate()
		new_pause_screen.closed.connect(pause_screen_closed)
		self.add_child(new_pause_screen)
		is_pause_screen_active = true


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")


func pause_screen_closed() -> void:
	is_pause_screen_active = false
