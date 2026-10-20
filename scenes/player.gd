extends CharacterBody3D

var speed: float = 8
var jump_velocity: float = 25

var acceleration: float = 50
var deceleration: float = 50

var is_gliding := false
# Move this elsewhere to easier change it
var gravity: float = 70

var max_glide_speed: float = 60
var starting_glide_speed: float = 20
var glide_speed: float = 10
var glide_speed_y: float
var glide_speed_retainment_rate: float = 0.05
var glide_turning_speed_decrease: float = 8

var previous_yaw: float = 0

func _physics_process(delta: float) -> void:
	var yaw_difference: float = previous_yaw - self.rotation.y
	
	if Input.is_action_just_pressed("glide"):
		is_gliding = !is_gliding
		$GliderModel.visible = is_gliding
		glide_speed = starting_glide_speed
		glide_speed_y = 0
	
	if is_gliding:
		if is_on_floor():
			is_gliding = false
		
		var camera_direction: Vector3 = -%Camera.global_basis.z
		
		var face_direction_up = Vector3.UP.dot(camera_direction)
		if face_direction_up > 0: #Looking above the horizon
			print("llonign up")
			glide_speed = move_toward(glide_speed, 0, gravity * delta * glide_speed_retainment_rate)
			glide_speed_y = move_toward(glide_speed_y, -gravity, gravity * delta * glide_speed_retainment_rate)
		else:
			glide_speed += Vector3.DOWN.dot(camera_direction) * delta * speed
			glide_speed = clampf(glide_speed, 0, max_glide_speed)
			glide_speed_y = 0 #move_toward(glide_speed_y, 0, gravity * delta)
			
		glide_speed -= yaw_difference * delta * glide_turning_speed_decrease
		
		print("Glide speed: " + str(glide_speed))
		
		self.velocity = velocity.move_toward(camera_direction * glide_speed, acceleration * delta)
		self.velocity.y += glide_speed_y / 5
		#self.velocity.y -= gravity * 0.001
		#self.velocity.y = clamp(self.velocity.y, -gravity, INF)
		#self.velocity.y = -(glide_speed * glide_speed_retainment_rate) - (gravity * glide_speed_retainment_rate)
		#self.velocity.y = -abs(glide_speed - 2)
		print("Velocity y: " + str(self.velocity.y))
		if is_equal_approx(self.velocity.y, -gravity):
			is_gliding = false
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
		
	previous_yaw = self.rotation.y
		
	move_and_slide()
