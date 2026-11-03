extends Node3D

@onready var interactable_select_button: PackedScene = preload("res://scenes/interactable_select_button.tscn")

var objects_in_range: Dictionary[String, bool]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Player/InteractionArea.object_passed_interaction_zone.connect(manage_new_interactable_object)

# TODO Split it up into the object name and the object id
func manage_new_interactable_object(object_name: String, is_entering_zone: bool) -> void:
	if is_entering_zone:
		objects_in_range[object_name] = true
		var new_button: Button = interactable_select_button.instantiate()
		new_button.text = object_name
		new_button.object_id = object_name
		$InteractionUI/ScrollContainer/VBoxContainer.add_child(new_button)
	# Else, the object is leaving the zone
	else:
		# Make sure the object is in the dict before trying to erase
		objects_in_range[object_name] = false
		objects_in_range.erase(object_name)
		for child in $InteractionUI/ScrollContainer/VBoxContainer.get_children():
			if child.object_id == object_name:
				child.queue_free()
	"""
	if objects_in_range.size() == 0:
		print("No objects in range!")
	else:
		print("Objects in range: " + str(objects_in_range))
	"""
