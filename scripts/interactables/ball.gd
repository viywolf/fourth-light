extends InteractableObject

func _do_interaction():
	ItemInteractions.pick_up_item(self)
