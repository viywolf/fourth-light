extends NPC


func check_conditions() -> void:
	for condition in conditions:
		if condition == "is_holding_apple":
			print("apple")
			var balls = ItemInteractions.find_item_node_from_type("ball")
			print(balls)
			for item in balls:
				print(item)
				if ItemInteractions.held_item == item.get("object_id"):
					conditions["is_holding_apple"] = true
					# Delete the apple
					conditions["has_given_apple"] = true
					#set_condition("has_given_apple", true)
					ItemInteractions.items_to_delete.push_back(item)
	ItemInteractions.delete_items_in_deletion_queue()
