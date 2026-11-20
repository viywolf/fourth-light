extends CollisionShape3D

## Emitted when the player is grabbing on to a ledge
signal is_on_ledge(is_on_ledge: bool)

var objects_touching_ledge_detection: int = 0

func _on_one_way_collsion_area_body_entered(_body: Node3D) -> void:
	self.disabled = true
	await get_tree().create_timer(0.5).timeout
	self.disabled = false


func _on_one_way_collsion_area_body_exited(_body: Node3D) -> void:
	self.disabled = false


func _on_is_ledging_body_entered(_body: Node3D) -> void:
	if _body == PlayerInformation.player:
		return
	objects_touching_ledge_detection += 1
	is_on_ledge.emit(true)


func _on_is_ledging_body_exited(_body: Node3D) -> void:
	if _body == PlayerInformation.player:
		return
	objects_touching_ledge_detection -= 1
	if objects_touching_ledge_detection == 0:
		is_on_ledge.emit(false)
