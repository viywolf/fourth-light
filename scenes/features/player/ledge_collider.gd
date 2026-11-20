extends CollisionShape3D

## Emitted when the player is grabbing on to a ledge
signal is_on_ledge(is_on_ledge)


func _on_one_way_collsion_area_body_entered(_body: Node3D) -> void:
	self.disabled = true
	await get_tree().create_timer(0.5).timeout
	self.disabled = false


func _on_one_way_collsion_area_body_exited(_body: Node3D) -> void:
	self.disabled = false
