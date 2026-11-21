class_name DialogueMessage
extends Resource

@export var dialogue: String
@export_enum("normal", "slow", "fast") var dialogue_speed: String
@export var is_option: bool = false
@export var options: Array[String]
@export var options_next_dialogue_index: Array[int]

@export var special_effect: String
