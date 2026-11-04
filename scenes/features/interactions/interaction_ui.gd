extends CanvasLayer

@onready var interactable_select_button: PackedScene = preload("res://scenes/features/interactions/interactable_select_button.tscn")

@onready var buttons_container: Container = $ScrollContainer/ButtonsContainer

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if buttons_container.get_child_count() != 0:
			var body_interacted_with: String = buttons_container.get_child(0).object_id
			buttons_container.get_child(0).queue_free()
			for node in get_tree().get_nodes_in_group("interactables"):
				if str(node) == body_interacted_with:
					if node.get("is_interactable") == true:
						node._do_interaction()
					else:
						node.queue_free()
						print("This node has no interaction method")
		
	if buttons_container.get_child_count() == 0:
		$KeyPrompt.hide()
	else:
		$KeyPrompt.show()

func add_interactable_button(object_name: String, object_id: String) -> void:
	var new_button: Button = interactable_select_button.instantiate()
	new_button.text = object_name
	new_button.object_id = object_id
	buttons_container.add_child(new_button)
	
	
func delete_interactable_button(object_id: String) -> void:
	for child in buttons_container.get_children():
		if child.object_id == object_id:
			child.queue_free()
	
