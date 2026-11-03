extends CanvasLayer

@onready var interactable_select_button: PackedScene = preload("res://scenes/interactable_select_button.tscn")

@onready var buttons_container: Container = $ScrollContainer/ButtonsContainer

func add_interactable_button(object_name: String, object_id: String) -> void:
	var new_button: Button = interactable_select_button.instantiate()
	new_button.text = object_name
	new_button.object_id = object_id
	buttons_container.add_child(new_button)
	
	
func delete_interactable_button(object_id: String) -> void:
	for child in buttons_container.get_children():
		if child.object_id == object_id:
			child.queue_free()
	
