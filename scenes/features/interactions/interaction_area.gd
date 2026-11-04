extends Area3D

signal object_passed_interaction_zone(object_name: String, object_id: String, entered_zone: bool)


func _on_body_entered(body: Node3D) -> void:
	if body.has_method("_do_interaction") == false:
		return
	object_passed_interaction_zone.emit(body.name, str(body), true)


func _on_body_exited(body: Node3D) -> void:
	if body.has_method("_do_interaction") == false:
		return
	object_passed_interaction_zone.emit(body.name, str(body), false)
