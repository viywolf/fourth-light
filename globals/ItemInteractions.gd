extends Node

var objects_in_range: Dictionary[String, bool]

var is_holding_item: bool = false
var held_item: String

func pick_up_item(item: Node) -> void:
	if is_holding_item: 
		return
	is_holding_item = true
	var player: CharacterBody3D = get_tree().get_nodes_in_group("player")[0]
	if item is RigidBody3D:
		item.freeze = true
	item.reparent(player.get_node("HeldObjects"))
	item.position = Vector3.ZERO
	item.is_interactable = false
	print("set held item to " + str(item))
	held_item = str(item)


func drop_item(item: Node) -> void:
	var world: Node3D = get_tree().get_nodes_in_group("world")[0]
	item.reparent(world)
	if item is RigidBody3D:
		item.freeze = false
	is_holding_item = false
	item.is_interactable = true
	print("set held item to null")
	held_item = ""
