extends CanvasLayer

@onready var interactable_select_button: PackedScene = preload("res://scenes/features/interactions/interactable_select_button.tscn")

@onready var buttons_container: Container = $ScrollContainer/HBoxContainer/ButtonsContainer

var current_button_selected: int = 0

func _process(_delta: float) -> void:
	if buttons_container.get_child_count() == 0:
		$KeyPrompt.hide()
	else:
		$KeyPrompt.show()
	
	if ItemInteractions.is_holding_item == true:
		$ReleaseLabel.prompt()
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.is_pressed():
			GameStatus.is_middle_mouse_pressed = true
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.is_released():
			interact()
			GameStatus.is_middle_mouse_pressed = false
		if GameStatus.is_middle_mouse_pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
				current_button_selected += 1
			if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
				current_button_selected -= 1
			
		if buttons_container.get_child_count() == 0:
			return
		current_button_selected = posmod(current_button_selected, buttons_container.get_child_count())
		set_button_active(current_button_selected)
			


func interact() -> void:
	if current_button_selected < buttons_container.get_child_count():
		var button_chosen: Button = buttons_container.get_child(current_button_selected)
		if button_chosen.custom_info != null and button_chosen.object_type == "dialogue":
			var cur_dialogue: Node3D = Dialogue.current_dialogue
			cur_dialogue.choose_option(button_chosen.custom_info)
		var body_interacted_with: String = buttons_container.get_child(current_button_selected).object_id
		var matching_nodes: Array[Node] = ItemInteractions.find_item_node_from_id(body_interacted_with)
		for node: Node3D in matching_nodes:
			if node.get("is_interactable") == true:
				# If the interaction method return true (sucessful)
				if node.do_interaction() == true:
					delete_interactable_button(body_interacted_with)
			else:
				node.queue_free()
				print("This node has no interaction method")
		

## Object type could be NPC or dialogue
func add_interactable_button(object_name: String, object_id: String, object_type: String = "null", dialogue_option: Variant = null) -> void:
	if ItemInteractions.held_item == str(object_id) and object_id != "dialogue":
		return
	if GameStatus.is_talking_to_npc and object_type == "NPC":
		return
	var new_button: Control = interactable_select_button.instantiate()
	new_button.change_text(object_name)
	new_button.object_id = object_id
	new_button.object_type = object_type
	new_button.custom_info = dialogue_option
	buttons_container.add_child(new_button)
	if buttons_container.get_child_count() == 1:
		set_button_active(0)
	
	
func delete_interactable_button(object_id: String) -> void:
	for child in buttons_container.get_children():
		if child.object_id == object_id:
			child.queue_free()
	

func set_button_active(button_no: int) -> void:
	if buttons_container.get_child_count() == 0:
		return
	for i in range(buttons_container.get_child_count()):
		var cur_button: Control = buttons_container.get_children()[i]
		if i == button_no:
			cur_button.add_theme_color_override("font_color", Color(0.85, 0.777, 0.547, 1.0))
		else:
			cur_button.remove_theme_color_override("font_color")
			
