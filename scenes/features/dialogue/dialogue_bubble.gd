extends Node3D

const SIZE_RATIO: Vector2 = Vector2(3, 2)
const DEFAULT_TEXT_REVEAL_SPEED: float = 0.05

@onready var label: Label = $SubViewport/Control/Label
@onready var options_container: VBoxContainer = $SubViewport/Control/OptionsContainer

@export var player_left_message: String

@export var dialogue: Array[DialogueMessage]

var current_dialogue: int = -1

var option_chosen: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reveal_text("A")


func _process(delta: float) -> void:
	self.rotation.y = get_viewport().get_camera_3d().global_basis.z.x

func update_text_box_size() -> void:
	label.size.x


func reveal_text(message: String, text_speed: String = "normal") -> void:
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
	


func wait_for_response(message: String, options: Array[String], options_next_dialogue: Array[int]) -> void:
	await reveal_text(message, "fast")
	options_container.show()
	while option_chosen == -1:
		await get_tree().process_frame
	if option_chosen == 0:
		reveal_text(player_left_message)
	else:
		current_dialogue = options_next_dialogue[option_chosen - 1]
