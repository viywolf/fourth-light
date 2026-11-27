extends NPC


func on_item_taken(item: InteractableObject) -> void:
	# It should already be an item that is takable based 
	# in the dialogue_bubble script
	if item.object_type == "ball":
		update_condition("has_given_apple", true)
		ItemInteractions.delete_held_item(item)


func check_conditions() -> void:
	for condition in conditions:
		if condition == "is_holding_apple":
			var is_condition_true := false
			var balls = ItemInteractions.find_item_node_from_type("ball")
			for item in balls:
				if ItemInteractions.held_item == item:
					conditions["is_holding_apple"] = true
					is_condition_true = true
			if is_condition_true == false:
				conditions["is_holding_apple"] = false


func update_condition(condition_name: String, condition_new_value: bool) -> void:
	if conditions.get(condition_name) == null:
		printerr("Condition " + condition_name + " does not exist")
	conditions[condition_name] = condition_new_value
