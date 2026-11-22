extends Node3D

const SIZE_RATIO: Vector2 = Vector2(3, 2)
const DEFAULT_TEXT_REVEAL_SPEED: float = 0.05

const LAST_MESSAGE_TIMEOUT: float = 3

@onready var speech_bubble: MeshInstance3D = $SpeechBubble

@onready var label: Label = $SubViewport/Control/HBoxContainer/Label

@export var player_left_message: String

@export var full_dialogue: Array[DialogueMessage]

var is_starting_dialogue: bool = false

var current_dialogue: int = -1

var option_chosen: int = -1
var dialogue_cancelled: bool = false

var interaction_ui: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_starting_dialogue = true
	Dialogue.current_dialogue = self
	interaction_ui = PlayerInformation.player_controller.get_node("InteractionUI")


func _process(_delta: float) -> void:
	if is_starting_dialogue:
		is_starting_dialogue = false
		start_dialogue()


func start_dialogue(current_dialogue_index: int = 0) -> void:
	var i: int = current_dialogue_index 
	while i < full_dialogue.size():
		print(i)
		var dialogue: DialogueMessage = full_dialogue[i]
		if dialogue.is_option:
			var dialogue_jump_to = await wait_for_response(dialogue.dialogue, dialogue.dialogue_speed, dialogue.options, dialogue.options_next_dialogue_index)
			if dialogue_jump_to == -1:
				pass
			else:
				i = dialogue_jump_to
				continue
		else:
			await reveal_text(dialogue.dialogue, dialogue.dialogue_speed, dialogue.is_last_dialogue)
		if dialogue.is_last_dialogue:
			break
			
		if dialogue_cancelled:
			print("cancelled")
			dialogue_cancelled = false
			reveal_text(player_left_message)
			break
			
		await get_tree().create_timer(LAST_MESSAGE_TIMEOUT / 2).timeout
		i += 1
		
	await get_tree().create_timer(LAST_MESSAGE_TIMEOUT).timeout
	# or maybe hide it instead
	self.queue_free()


func update_text_box_size() -> void:
	label.custom_minimum_size.x = 100 * (len(label.text) / 8.0)
	
	speech_bubble.position.y = 0.6 #label.size.y / 1000.0
	
	if label.custom_minimum_size.x < 350:
		label.custom_minimum_size.x = 350
		


func reveal_text(message: String, text_speed: String = "normal", is_last_dialogue: bool = false) -> void:
	label.visible_characters = 0
	label.text = message
	
	update_text_box_size()
	
	var time_to_wait: float
	match text_speed:
		"normal": time_to_wait = DEFAULT_TEXT_REVEAL_SPEED
		"slow": time_to_wait = DEFAULT_TEXT_REVEAL_SPEED * 4
		"fast": time_to_wait = DEFAULT_TEXT_REVEAL_SPEED / 4
		_: printerr("Text speed needs to be 'normal', 'slow', or 'fast'")
	
	while label.visible_characters < label.text.length():
		label.visible_characters += 1
		await get_tree().create_timer(time_to_wait).timeout
		if dialogue_cancelled and is_last_dialogue == false:
			return
	


func wait_for_response(message: String, text_speed: String, options: Array[String], options_next_dialogue: Array[int]) -> int:
	await reveal_text(message, text_speed)
	
	for i in range(options.size()):
		interaction_ui.add_interactable_button(options[i], str(self), "dialogue", i + 1)
	while option_chosen == -1:
		await get_tree().process_frame
	if option_chosen == 0:
		print("bye")
		cancel_dialogue()
		return -1
	else:
		print("chose option " + str(option_chosen))
		return options_next_dialogue[option_chosen - 1]


func choose_option(option_index: int) -> void:
	option_chosen = option_index
	delete_option_select_buttons()


func cancel_dialogue() -> void:
	print("cancel dialogue function")
	dialogue_cancelled = true
	delete_option_select_buttons()
	if option_chosen == -1:
		option_chosen = 0


func delete_option_select_buttons() -> void:
	interaction_ui.delete_interactable_button(str(self))
