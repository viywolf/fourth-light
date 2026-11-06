extends CanvasLayer

@onready var interactable_select_button: PackedScene = preload("res://scenes/features/interactions/interactable_select_button.tscn")

@onready var buttons_container: Container = $ScrollContainer/ButtonsContainer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if buttons_container.get_child_count() != 0:
			var body_interacted_with: String = buttons_container.get_child(0).object_id
			for node in get_tree().get_nodes_in_group("interactables"):
				if str(node) == body_interacted_with:
					if node.get("is_interactable") == true:
						node._do_interaction()
					else:
						node.queue_free()
						print("This node has no interaction method")
			delete_interactable_button(body_interacted_with)
			buttons_container.get_child(0).queue_free()
		
	if buttons_container.get_child_count() == 0:
		$KeyPrompt.hide()
	else:
		$KeyPrompt.show()
		
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.is_pressed():
			print("afjsajlk")
			GameStatus.is_middle_mouse_pressed = true
		if event.button_index == MOUSE_BUTTON_MIDDLE and event.is_released():
			print("Relasededed!!!!!")
			GameStatus.is_middle_mouse_pressed = false
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			print("Downnn")
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			print("Up upu up")
			

func add_interactable_button(object_name: String, object_id: String) -> void:
	if ItemInteractions.held_item == object_id:
		return
	var new_button: Button = interactable_select_button.instantiate()
	new_button.text = object_name
	new_button.object_id = object_id
	buttons_container.add_child(new_button)
	
	
func delete_interactable_button(object_id: String) -> void:
	for child in buttons_container.get_children():
		if child.object_id == object_id:
			child.queue_free()
	
