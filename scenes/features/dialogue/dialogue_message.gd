class_name DialogueMessage
extends Resource

@export var dialogue: String
@export_enum("normal", "slow", "fast") var dialogue_speed: String = "normal"
@export var is_option: bool = false
@export var options: Array[String]
@export var options_next_dialogue_index: Array[int]
@export var is_last_dialogue: bool = false

@export var condition: String
@export var special_effect: String
