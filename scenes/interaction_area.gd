extends Area3D

signal object_passed_interaction_zone(object_name: String, entered_zone: bool)


func _on_body_entered(body: Node3D) -> void:
	object_passed_interaction_zone.emit(body.name, true)


func _on_body_exited(body: Node3D) -> void:
	object_passed_interaction_zone.emit(body.name, false)
