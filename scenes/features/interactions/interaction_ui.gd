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
			
		current_button_selected = posmod(current_button_selected, buttons_container.get_child_count())
		set_button_active(current_button_selected)
			


func interact() -> void:
	if current_button_selected < buttons_container.get_child_count():
		var body_interacted_with: String = buttons_container.get_child(current_button_selected).object_id
		for node in get_tree().get_nodes_in_group("interactables"):
			if str(node) == body_interacted_with:
				if node.get("is_interactable") == true:
					# If the interaction method return true (sucessful)
					if node._do_interaction() == true:
						delete_interactable_button(body_interacted_with)
				else:
					node.queue_free()
					print("This node has no interaction method")
		

func add_interactable_button(object_name: String, object_id: String) -> void:
	if ItemInteractions.held_item == object_id:
		return
	var new_button: Control = interactable_select_button.instantiate()
	new_button.change_text(object_name)
	new_button.object_id = object_id
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
			
