extends Area3D

## This is connected to player_controller.gd's manage_new_interactable_object
signal object_passed_interaction_zone(object_name: String, object_id: String, entered_zone: bool)

# TODO: work out how to link npc to this system

func _on_body_entered(body: Node3D) -> void:
	
	print(body)
	var body_is_interactable_value: Variant = body.get("is_interactable")
	if body_is_interactable_value == false or body_is_interactable_value == null:
		return
	if body is InteractableObject:
		object_passed_interaction_zone.emit(body.name, str(body.object_id), true)
	if body is NPC:
		object_passed_interaction_zone.emit(body.npc_name, str(body), true)
		print("Hi npc")


func _on_body_exited(body: Node3D) -> void:
	print(body)
	var body_is_interactable_value: Variant = body.get("is_interactable")
	if body_is_interactable_value == false or body_is_interactable_value == null:
		return
	if body is InteractableObject:
		object_passed_interaction_zone.emit(body.name, str(body.object_id), false)
	if body is NPC:
		object_passed_interaction_zone.emit(body.npc_name, str(body), false)
		print("Bye npc")
