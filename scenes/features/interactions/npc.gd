extends CharacterBody3D

class_name NPC

@export var is_interactable: bool = true
@export var npc_name: String

# Make it so after you interact, the interact prompt pops back up

func do_interaction() -> bool:
	# Start talk dialogue
	print("yap yap yap")
	return true
