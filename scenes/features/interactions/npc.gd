@abstract
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

@export var conditions: Dictionary[String, bool]

@export var items_to_take: Array[String]

var is_player_in_range: bool = false
var did_player_just_leave: bool = false
var current_dialogue_bubble: Node3D


@abstract func check_conditions() -> void
@abstract func on_item_taken(item: InteractableObject) -> void

func _ready() -> void:
	load_data()


func do_interaction() -> bool:
	check_conditions()
	var new_dialogue: Node3D = dialogue_bubble_scene.instantiate()
	new_dialogue.player_left_message = player_left_message
	new_dialogue.full_dialogue = dialogue
	new_dialogue.conditions = conditions
	new_dialogue.items_to_take = items_to_take
	new_dialogue.item_taken.connect(on_item_taken)
	new_dialogue.dialogue_finished.connect(_on_dialogue_finished)
	current_dialogue_bubble = new_dialogue
	self.add_child(new_dialogue)
	new_dialogue.is_starting_dialogue = true
	return true


func save() -> Dictionary:
	var data_to_save := {
		"filename": self.scene_file_path,
	}
	
	for condition in conditions.keys():
		data_to_save[condition] = conditions[condition]
	
	return data_to_save


func load_data() -> void:
	var data: Dictionary = SaveFile.get_save_data(self.scene_file_path)
	for key in data.keys():
		if conditions.get(key) != null:
			conditions[key] = data[key]


func _on_talk_area_body_entered(body: Node3D) -> void:
	if body == PlayerInformation.player:
		is_player_in_range = true


func _on_talk_area_body_exited(body: Node3D) -> void:
	if body == PlayerInformation.player:
		is_player_in_range = false
		did_player_just_leave = true
		if current_dialogue_bubble != null:
			print("npc cancel")
			current_dialogue_bubble.cancel_dialogue()


func _on_dialogue_finished() -> void:
	if is_player_in_range:
		PlayerInformation.player_controller.get_node("InteractionUI").add_interactable_button(npc_name, str(self))
