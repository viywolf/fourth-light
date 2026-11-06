extends Node3D

var time_drop_held: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("drop"):
		if get_child_count() > 0:
			ItemInteractions.drop_item(get_child(0), time_drop_held)
	if Input.is_action_pressed("drop"):
		time_drop_held += delta
		time_drop_held = clampf(time_drop_held, 0, ItemInteractions.MAX_DROP_HOLD_TIME)
		
		# Find and get the throw progress bar
		var all_ui = get_tree().get_nodes_in_group("ui")
		var throw_progress_bar: ProgressBar = null
		for node in all_ui:
			if node.name == "InteractionUI":
				throw_progress_bar = node.get_node_or_null("ThrowProgressBar")
				
		if throw_progress_bar != null:
			throw_progress_bar.update_progress_bar(time_drop_held / ItemInteractions.MAX_DROP_HOLD_TIME)
			if ItemInteractions.is_holding_item:
				throw_progress_bar.show()
		else:
			printerr("No prograss bar availiable for throwing. (Player: Held Objects)")
	else:
		time_drop_held = 0
