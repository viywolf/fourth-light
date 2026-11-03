extends Node3D


var objects_in_range: Dictionary[String, bool]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Player/InteractionArea.object_passed_interaction_zone.connect(manage_new_interactable_object)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func manage_new_interactable_object(object_name: String, is_entering_zone: bool) -> void:
	if is_entering_zone:
		objects_in_range[object_name] = true
	# Else, the object is leaving the zone
	else:
		# Make sure the object is in the dict before trying to erase
		objects_in_range[object_name] = false
		objects_in_range.erase(object_name)
		
	if objects_in_range.size() == 0:
		print("No objects in range!")
	else:
		print("Objects in range: " + str(objects_in_range))
