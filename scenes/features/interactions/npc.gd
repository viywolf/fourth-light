extends CharacterBody3D

class_name NPC

## This detects if the player is in the area
## if the player leaves, cancel the dialogue and play a special dialogue
@onready var talk_area: Area3D = $TalkArea

@export var is_interactable: bool = true
@export var npc_name: String

var did_player_just_leave: bool = false

# Make it so after you interact, the interact prompt pops back up

func do_interaction() -> bool:
	# Start talk dialogue
	print("yap yap yap")
	return true


func _on_talk_area_body_exited(body: Node3D) -> void:
	if body == PlayerInformation.player:
		did_player_just_leave = true
