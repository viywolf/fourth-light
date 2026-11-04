extends Node

func pick_up_item(item: Node) -> void:
	var player: CharacterBody3D = get_tree().get_nodes_in_group("player")[0]
	if item is RigidBody3D:
		item.freeze = true
		item.set_collision_layer_value(1, false) 
	item.reparent(player.get_node("HoldPosition"))
