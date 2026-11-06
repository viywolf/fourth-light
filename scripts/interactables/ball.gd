extends InteractableObject

func _do_interaction() -> bool:
	return ItemInteractions.pick_up_item(self)
