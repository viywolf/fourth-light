extends CharacterBody3D

class_name NPC

var dialogue_bubble_scene: PackedScene = preload("res://scenes/features/dialogue/dialogue_bubble.tscn")

## This detects if the player is in the area
## if the player leaves, cancel the dialogue and play a special dialogue
@onready var talk_area: Area3D = $TalkArea

@export var is_interactable: bool = true
@export var npc_name: String

@export var player_left_message: String
@export var dialogue: Array[DialogueMessage]


@export var conditions: Dictionary[String, Variant]

var did_player_just_leave: bool = false
var current_dialogue_bubble: Node3D


# Make it so after you interact, the interact prompt pops back up

func do_interaction() -> bool:
	var new_dialogue: Node3D = dialogue_bubble_scene.instantiate()
	new_dialogue.player_left_message = player_left_message
	new_dialogue.full_dialogue = dialogue
	current_dialogue_bubble = new_dialogue
	self.add_child(new_dialogue)
	new_dialogue.is_starting_dialogue = true
	return true


func _on_talk_area_body_exited(body: Node3D) -> void:
	if body == PlayerInformation.player:
		did_player_just_leave = true
		if current_dialogue_bubble != null:
			print("npc cancel")
			current_dialogue_bubble.cancel_dialogue()
