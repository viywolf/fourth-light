extends CharacterBody3D

var speed: float = 8
var jump_velocity: float = 25

var acceleration: float = 50
var deceleration: float = 50

var is_gliding := false
# Move this elsewhere to easier change it
var gravity: float = 70
var glide_speed_y: float = 10
var glide_speed_retainment_rate = 0.2

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("glide"):
		is_gliding = !is_gliding
	
	if is_gliding:
		if is_on_floor():
			is_gliding = false
		
		var camera_direction: Vector3 = -%Camera.global_basis.z
		
		var face_direction_up = Vector3.UP.dot(camera_direction)
		if face_direction_up > 0: #Looking above the horizon
			print("llonign up")
			glide_speed_y = move_toward(glide_speed_y, 0, gravity * delta * glide_speed_retainment_rate)
		else:
			glide_speed_y += Vector3.DOWN.dot(camera_direction)
			
		print(glide_speed_y)
		
		self.velocity = velocity.move_toward(camera_direction * speed, acceleration * delta)
		move_and_slide()
		return
	
	var raw_input: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var local_forward: Vector3 = %Camera.global_basis.z
	var local_right: Vector3 = %Camera.global_basis.x
	
	var movement_direction: Vector3 = (local_forward * raw_input.y) + (local_right * raw_input.x)
	movement_direction.y = 0.0
	movement_direction = movement_direction.normalized()
	-%Camera.global_basis.z
	if raw_input != Vector2.ZERO:
		self.velocity = velocity.move_toward(movement_direction * speed, acceleration * delta)
	else:
		self.velocity = velocity.move_toward(Vector3.ZERO, deceleration * delta)
	
	var is_starting_jump: bool = Input.is_action_just_pressed("jump") and is_on_floor()
	
	if is_starting_jump:
		self.velocity.y = jump_velocity
	
	if is_on_floor() == false:
		self.velocity.y = move_toward(self.velocity.y, -gravity, gravity * delta)
		
		
	move_and_slide()
