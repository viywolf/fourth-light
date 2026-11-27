extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveFile.load_game()
	self.wait_time = Settings.autosave_time
	self.start()
	


func _on_timeout() -> void:
	SaveFile.save_game()
