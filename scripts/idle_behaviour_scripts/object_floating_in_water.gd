extends Node3D

@export var max_float_velocity: float = 0.005
@export var float_acceleration: float = 0.005

var original_position: Vector3

var time_passed: float

func _ready() -> void:
	original_position = self.position
	time_passed += randf_range(0, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	time_passed += delta * float_acceleration
	var vel = (max_float_velocity / 2.0) - pingpong(time_passed, max_float_velocity)
	self.position.y += vel
	self.rotation_degrees.z += delta * 4
