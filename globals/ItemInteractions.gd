extends Node

var objects_in_range: Dictionary[String, bool]

const THROW_SPEED_MULTIPLIER: float = 30

const MAX_DROP_HOLD_TIME: float = 3

var is_holding_item: bool = false

## The name/id of the node this is
var held_item: String

func pick_up_item(item: Node) -> bool:
	if is_holding_item: 
		return false
	is_holding_item = true
	if GameStatus.player == null:
		printerr("No player node set")
	if item is RigidBody3D:
		item.freeze = true
	item.reparent(GameStatus.player.get_node("HeldObjects"))
	item.position = Vector3.ZERO
	item.is_interactable = false
	held_item = str(item)
	return true

func drop_item(item: Node, time_held: float) -> void:
	var world: Node3D = get_tree().get_nodes_in_group("world")[0]
	item.reparent(world)
	if GameStatus.player == null:
		printerr("Not player node set")
	if item is RigidBody3D:
		item.freeze = false
		var throw_direction: Vector3 = GameStatus.player.transform.basis.z.normalized()
		item.apply_central_force(time_held * THROW_SPEED_MULTIPLIER * throw_direction)
	is_holding_item = false
	item.is_interactable = true
	held_item = ""
	
	# Find and get the throw progress bar
	var all_ui = get_tree().get_nodes_in_group("ui")
	var throw_progress_bar: ProgressBar = null
	for node in all_ui:
		if node.name == "InteractionUI":
			throw_progress_bar = node.get_node_or_null("ThrowProgressBar")
			
	if throw_progress_bar != null:
		throw_progress_bar.update_progress_bar(0)
		throw_progress_bar.hide()
	else:
		printerr("No prograss bar availiable for throwing. (ItemInteractions)")



func delete_held_item(item: Node) -> void:
	if is_holding_item == false:
		printerr("Not holding " + str(item) + ", unable to delete")
	item.queue_free()
	is_holding_item = false
	held_item = ""


## Finds the node that corresponds to the id belonging to the group interactables
func find_item_node_from_id(item_id: String) -> Array[Node]:
	var matching_nodes: Array[Node]
	for node: Node3D in get_tree().get_nodes_in_group("interactables"):
		if str(node) == item_id:
			matching_nodes.push_back(node)
	return matching_nodes


## Finds the node that corresponds to the type belonging to the group interactables
func find_item_node_from_type(item_type: String) -> Array[Node]:
	var matching_nodes: Array[Node]
	for node: Node3D in get_tree().get_nodes_in_group("interactables"):
		if node.get("object_type") != null and node.object_type == item_type:
			matching_nodes.push_back(node)
	return matching_nodes
