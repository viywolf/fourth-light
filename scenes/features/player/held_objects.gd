extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("drop"):
		if get_child_count() > 0:
			ItemInteractions.drop_item(get_child(0))
