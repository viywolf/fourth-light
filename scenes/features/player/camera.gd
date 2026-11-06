extends Node3D

@onready var raycast: RayCast3D = $RayCast3D

@export_range(0, 1) var mouse_sensitivity := 0.25

var spring_arm_length: float = 5
var min_spring_arm_length: float = 3
var max_spring_arm_length: float = 10


var camera_input_direction := Vector2.ZERO


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion
		and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
			camera_input_direction = event.screen_relative * mouse_sensitivity
	if event is InputEventMouseButton:
		if event.is_pressed() and GameStatus.is_middle_mouse_pressed == false:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				spring_arm_length *= 0.9
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				spring_arm_length *= 1.1
			
			
func _physics_process(delta: float) -> void:
	self.rotation.x -= camera_input_direction.y * delta
	self.rotation.x = clamp(self.rotation.x, -PI / 3.0, PI / 6.0)
	self.rotation.y -= camera_input_direction.x * delta
	camera_input_direction = Vector2.ZERO
	self.global_position = %Player.global_position
	
	spring_arm_length = clampf(spring_arm_length, min_spring_arm_length, max_spring_arm_length)
	$SpringArm3D.spring_length = spring_arm_length
	
	raycast.transform = $SpringArm3D.transform
	raycast.position.y -= 0.1
