extends CharacterBody3D

var speed: float = 8
var jump_velocity: float = 25

var acceleration: float = 50
var deceleration: float = 50

# Move this elsewhere to easier change it
var gravity: float = 70

func _physics_process(delta: float) -> void:
	var raw_input: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var local_forward: Vector3 = %Camera.global_basis.z
	var local_right: Vector3 = %Camera.global_basis.x
	
	var movement_direction: Vector3 = (local_forward * raw_input.y) + (local_right * raw_input.x)
	movement_direction.y = 0.0
	movement_direction = movement_direction.normalized()
	
	if raw_input != Vector2.ZERO:
		self.velocity = velocity.move_toward(movement_direction * speed, acceleration * delta)
	else:
		self.velocity = velocity.move_toward(Vector3.ZERO, deceleration * delta)
	
	var is_starting_jump: bool = Input.is_action_just_pressed("jump") and is_on_floor()
	
	if is_starting_jump:
		self.velocity.y = jump_velocity
	else:
		self.velocity.y = move_toward(self.velocity.y, -gravity, gravity * delta)
		
		
	move_and_slide()
