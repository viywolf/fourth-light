@abstract extends Node
class_name InteractableObject

@export var is_interactable: bool = true

var object_id: String

@abstract func _do_interaction()

func _ready() -> void:
	object_id = str(self)
