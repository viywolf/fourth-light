extends InteractableObject  

func do_interaction() -> bool:  
	return ItemInteractions.pick_up_item(self) 
