extends Node3D

@export_range(0, 1) var mouse_sensitivity := 0.25

var camera_input_direction := Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion
		and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
			camera_input_direction = event.screen_relative * mouse_sensitivity
			
func _physics_process(delta: float) -> void:
	self.rotation.x -= camera_input_direction.y * delta
	self.rotation.x = clamp(self.rotation.x, -PI / 3.0, PI / 6.0)
	self.rotation.y -= camera_input_direction.x * delta
	camera_input_direction = Vector2.ZERO
