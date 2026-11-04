extends Node3D

var objects_in_range: Dictionary[String, bool]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Player/InteractionArea.object_passed_interaction_zone.connect(manage_new_interactable_object)


func manage_new_interactable_object(object_name: String, object_id: String, is_entering_zone: bool) -> void:
	if is_entering_zone:
		$InteractionUI.add_interactable_button(object_name, object_id)
	# Else, the object is leaving the zone
	else:
		$InteractionUI.delete_interactable_button(object_id)
