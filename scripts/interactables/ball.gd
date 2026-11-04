extends InteractableObject


func _do_interaction():
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position:y", self.position.y + 0.5, 0.2)
	tween.parallel().tween_property(self, "rotation:y", PI, 0.2)
	tween.tween_property(self, "position:y", self.position.y + 0.4, 0.1)
	await tween.finished
	ItemInteractions.pick_up_item(self)
