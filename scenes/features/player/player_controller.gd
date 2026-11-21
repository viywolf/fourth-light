extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerInformation.player_controller = self
	GameStatus.get_player_node()
	$Player/InteractionArea.object_passed_interaction_zone.connect(manage_new_interactable_object)


## Whenever an object passes the player's interaction zone, and 
## has a variable called is_interactable which is true,
## add it to the ui
func manage_new_interactable_object(object_name: String, object_id: String, is_entering_zone: bool) -> void:
	if ItemInteractions.is_holding_item and ItemInteractions.held_item == object_id:
		return
	if is_entering_zone:
		ItemInteractions.objects_in_range[object_id] = true
		$InteractionUI.add_interactable_button(object_name, object_id)
		#npcs reach here
	# Else, the object is leaving the zone
	else:
		$InteractionUI.delete_interactable_button(object_id)
		ItemInteractions.objects_in_range[object_id] = false
