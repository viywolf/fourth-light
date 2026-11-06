extends Label

var has_been_prompted: bool = false

func prompt() -> void:
	if has_been_prompted:
		return
	has_been_prompted = true
	self.show()
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 2)
	await tween.finished
	self.hide()
