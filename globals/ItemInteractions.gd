extends Node

var objects_in_range: Dictionary[String, bool]

const THROW_SPEED_MULTIPLIER: float = 30

const MAX_DROP_HOLD_TIME: float = 3

var is_holding_item: bool = false
var held_item: String

var player: CharacterBody3D

func pick_up_item(item: Node) -> void:
	if is_holding_item: 
		return
	is_holding_item = true
	if player == null:
		player = get_tree().get_nodes_in_group("player")[0]
	if item is RigidBody3D:
		item.freeze = true
	item.reparent(player.get_node("HeldObjects"))
	item.position = Vector3.ZERO
	item.is_interactable = false
	held_item = str(item)


func drop_item(item: Node, time_held: float) -> void:
	var world: Node3D = get_tree().get_nodes_in_group("world")[0]
	item.reparent(world)
	if player == null:
		player = get_tree().get_nodes_in_group("player")[0]
	if item is RigidBody3D:
		item.freeze = false
		var throw_direction: Vector3 = player.transform.basis.z.normalized()
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
