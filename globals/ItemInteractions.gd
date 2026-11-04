extends Node

var is_holding_item: bool = false

func pick_up_item(item: Node) -> void:
	if is_holding_item: 
		return
	var player: CharacterBody3D = get_tree().get_nodes_in_group("player")[0]
	if item is RigidBody3D:
		item.freeze = true
	item.reparent(player.get_node("HeldObjects"))
	item.position = Vector3.ZERO
	is_holding_item = true
	item.is_interactable = false


func drop_item(item: Node) -> void:
	var world: Node3D = get_tree().get_nodes_in_group("world")[0]
	item.reparent(world)
	if item is RigidBody3D:
		item.freeze = false
	is_holding_item = false
	item.is_interactable = true
