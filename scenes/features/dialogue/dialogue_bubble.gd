extends Node3D

const SIZE_RATIO: Vector2 = Vector2(3, 2)
const DEFAULT_TEXT_REVEAL_SPEED: float = 0.05

@onready var text_bubble: PanelContainer = $Control/TextBubble
@onready var label: Label = $Control/TextBubble/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	update_text_box_size()
	reveal_text("Example text here")


func update_text_box_size() -> void:
	var vertical_height: float = label.size.y
	text_bubble.size.x = vertical_height * (SIZE_RATIO.x / SIZE_RATIO.y)


func reveal_text(message: String, text_speed: String = "normal") -> void:
	
	var time_to_wait: float
	match text_speed:
		"normal": time_to_wait = DEFAULT_TEXT_REVEAL_SPEED
		"slow": time_to_wait = DEFAULT_TEXT_REVEAL_SPEED * 4
		"fast": time_to_wait = DEFAULT_TEXT_REVEAL_SPEED / 4
		_: printerr("Text speed needs to be 'normal', 'slow', or 'fast'")
	
	label.visible_characters = 0
	label.text = message
	while label.visible_characters < label.text.length():
		label.visible_characters += 1
		await get_tree().create_timer(time_to_wait).timeout
	
