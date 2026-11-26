extends NPC

func check_conditions() -> void:
	print(conditions)
	for condition in conditions:
		print(condition)
		if condition == "is_holding_apple":
			var is_condition_true := false
			var balls = ItemInteractions.find_item_node_from_type("ball")
			for item in balls:
				if ItemInteractions.held_item == item.get("object_id"):
					conditions["is_holding_apple"] = true
					is_condition_true = true
			if is_condition_true == false:
				conditions["is_holding_apple"] = false
	ItemInteractions.delete_items_in_deletion_queue()


func update_condition(condition_name: String, condition_new_value: bool) -> void:
	if conditions.get(condition_name) == null:
		printerr("Condition " + condition_name + " does not exist")
	conditions[condition_name] = condition_new_value
