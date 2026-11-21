extends Node3D

const SIZE_RATIO: Vector2 = Vector2(3, 2)
const DEFAULT_TEXT_REVEAL_SPEED: float = 0.05

@onready var label: Label = $SubViewport/Control/Label
@onready var options_container: VBoxContainer = $SubViewport/Control/OptionsContainer

@export var player_left_message: String

@export var full_dialogue: Array[DialogueMessage]

var is_starting_dialogue: bool = false

var current_dialogue: int = -1

var option_chosen: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_starting_dialogue = true


func _process(delta: float) -> void:
	self.rotation.y = get_viewport().get_camera_3d().global_basis.z.x
	if is_starting_dialogue:
		is_starting_dialogue = false
		start_dialogue()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"):
		choose_option(0)


func start_dialogue(current_dialogue_index: int = 0) -> void:
	print("A")
	for i in range(current_dialogue_index, full_dialogue.size()):
		var dialogue: DialogueMessage = full_dialogue[i]
		if dialogue.is_option:
			print("BB")
			var dialogue_jump_to = await wait_for_response(dialogue.dialogue, dialogue.options, dialogue.options_next_dialogue_index)
			if dialogue_jump_to == -1:
				continue
			else:
				i = dialogue_jump_to
		else:
			print("AA")
			await reveal_text(dialogue.dialogue, dialogue.dialogue_speed)
	print("Finish dialogue")


func update_text_box_size() -> void:
	label.size.x = 100


func reveal_text(message: String, text_speed: String = "normal") -> void:
	print("B")
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
	


func wait_for_response(message: String, options: Array[String], options_next_dialogue: Array[int]) -> int:
	print("C")
	await reveal_text(message, "fast")
	
	for i in range(options_container.get_child_count()):
		var button = options_container.get_child(i)
		button.pressed.connect(choose_option.bind(i))
	options_container.show()
	while option_chosen == -1:
		await get_tree().process_frame
	if option_chosen == 0:
		reveal_text(player_left_message)
		return -1
	else:
		return options_next_dialogue[option_chosen - 1]


func choose_option(option_index: int) -> void:
	option_chosen = option_index
